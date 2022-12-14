// Copyright © 2022 Brian Drelling. All rights reserved.

import Logging
import XCTest

protocol LogHandlerValidating: XCTestCase {}

extension LogHandlerValidating {
    /// Validates that a LogHandler has been properly implemented.
    ///
    /// This test case has been copied nearly verbatim from the swift-log API documentation.
    /// See [LogHandler](https://apple.github.io/swift-log/docs/current/Logging/Protocols/LogHandler.html) for more information.
    func validateLogHandler(_ factory: @escaping (String) -> LogHandler) {
        var logger1 = Logger(label: "first logger", factory: factory)
        logger1.logLevel = .debug
        logger1[metadataKey: "only-on"] = "first"

        var logger2 = logger1
        logger2.logLevel = .error // this must not override `logger1`'s log level
        logger2[metadataKey: "only-on"] = "second" // this must not override `logger1`'s metadata

        XCTAssertEqual(.debug, logger1.logLevel)
        XCTAssertEqual(.error, logger2.logLevel)
        XCTAssertEqual("first", logger1[metadataKey: "only-on"])
        XCTAssertEqual("second", logger2[metadataKey: "only-on"])
    }
}
