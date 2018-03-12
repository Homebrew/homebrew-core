class Bartycrouch < Formula
  desc "Incrementally update your Strings files"
  homepage "https://github.com/Flinesoft/BartyCrouch"
  url "https://github.com/Flinesoft/BartyCrouch/archive/3.11.1.tar.gz"
  sha256 "49d53741608c1076bf74b7da2ab5e854762712fe5656b89a496fb0261e7ad3f0"

  bottle do
    cellar :any_skip_relocation
    sha256 "04d8bb53a3e5469dc89aa4fad740a36ddebe66a8d0fa8025a7aacc74b7875620" => :high_sierra
    sha256 "cc048beb703aeb1d0ec26acfe16969c65cc0d160a44dde0eab04287f618443c5" => :sierra
  end

  depends_on :xcode => ["9.0", :build]

  def install
    xcodebuild "-project", "BartyCrouch.xcodeproj",
               "-scheme", "BartyCrouch CLI",
               "SYMROOT=build",
               "DSTROOT=#{prefix}",
               "INSTALL_PATH=/bin",
               "-verbose",
               "install"
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

    system bin/"bartycrouch", "code", "-p", testpath, "-l", testpath, "-a"
    assert_match /"oldKey" = "/, File.read("en.lproj/Localizable.strings")
    assert_match /"test" = "/, File.read("en.lproj/Localizable.strings")
  end
end
