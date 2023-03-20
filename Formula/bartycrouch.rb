class Bartycrouch < Formula
  desc "Incrementally update/translate your Strings files"
  homepage "https://github.com/FlineDev/BartyCrouch"
  url "https://github.com/FlineDev/BartyCrouch.git",
      tag:      "4.14.2",
      revision: "a81a6ab4cc5c5346f942ae1becc7dfbc4498ab57"
  license "MIT"
  head "https://github.com/FlineDev/BartyCrouch.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "c8c0dee7be70232eddd703a234548d9f79f751fdef1902e94337e0774d1817c3"
    sha256 cellar: :any, arm64_monterey: "087f446c620c908fee527b89659fc7a2792fac5cf021681ea8c77ca3df3313a7"
    sha256 cellar: :any, ventura:        "60002a56fce98fabcf4b03e154d4c9b1844fb76d79ff5316a2a3549a1f85235d"
    sha256 cellar: :any, monterey:       "8603c26b5ab1b2541e89f0a8bb75e81f3e4a2e513f559831a29e2ba3b26c1ce7"
  end

  depends_on xcode: ["14.0", :build]
  depends_on :macos

  def install
    system "make", "install", "prefix=#{prefix}"

    # lib_InternalSwiftSyntaxParser is taken from Xcode, so it's a universal binary.
    deuniversalize_machos(lib/"lib_InternalSwiftSyntaxParser.dylib")
  end

  test do
    (testpath/"Test.swift").write <<~EOS
      import Foundation

      class Test {
        func test() {
            NSLocalizedString("test", comment: "")
        }
      }
    EOS

    (testpath/"en.lproj/Localizable.strings").write <<~EOS
      /* No comment provided by engineer. */
      "oldKey" = "Some translation";
    EOS

    system bin/"bartycrouch", "update"
    assert_match '"oldKey" = "', File.read("en.lproj/Localizable.strings")
    assert_match '"test" = "', File.read("en.lproj/Localizable.strings")
  end
end
