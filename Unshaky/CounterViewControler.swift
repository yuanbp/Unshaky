//
//  CounterViewControler.swift
//  Unshaky
//
//  Created by Xinhong LIU on 4/27/19.
//  Copyright © 2019 Nested Error. All rights reserved.
//

import Cocoa

class CounterViewControler: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var statLabel: NSTextField!
    
    var keyCodeToString = [Int: String]()
    var keyCounters = [Counter.KeyCounter]()

    override func viewDidLoad() {
        // sync ShakyPressPreventer.keyCodeToString to keyCodeToString
        for entry in ShakyPressPreventer.keyCodeToString {
            keyCodeToString[entry.key.intValue] = entry.value
        }

        super.viewDidLoad()

        updateCounters()
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        NotificationCenter.default.addObserver(self, selector: #selector(updateCounters), name: .counterUpdate, object: nil)
    }

    override func viewWillDisappear() {
        NotificationCenter.default.removeObserver(self)
        super.viewWillDisappear()
    }

    func loadKeyCounters() {
        keyCounters = Counter.shared.keyCounters.filter { keyCodeToString[$0.keyCode] != nil }
    }

    // MARK: NSTableViewDataSource
    func numberOfRows(in tableView: NSTableView) -> Int {
        return keyCounters.count
    }

    // MARK: NSTableViewDelegate
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        let keyCounter = keyCounters[row]
        if (tableColumn?.identifier)!.rawValue == "key" {
            return keyCodeToString[keyCounter.keyCode]!
        }
        if (tableColumn?.identifier)!.rawValue == "delay" {
            return "\(keyCounter.count)"
        }
        return nil
    }

    @objc func updateCounters() {
        statLabel.stringValue = Counter.shared.statString
        loadKeyCounters()
        tableView.reloadData()
    }

    @IBAction func resetStat(_ sender: Any) {
        Counter.shared.reset()
    }
}
