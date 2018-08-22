class Bartycrouch < Formula
  desc "Incrementally update your Strings files"
  homepage "https://github.com/Flinesoft/BartyCrouch"
  url "https://github.com/Flinesoft/BartyCrouch/archive/3.13.1.tar.gz"
  sha256 "86a48d807e2028061cbdcd63ad021122cc60408327a8de32daf332344332bd92"

  bottle do
    cellar :any_skip_relocation
    sha256 "a26c3afa9894c89d09350f6d233744fd104ac07b63f0d6ae3c533264957b8e05" => :mojave
    sha256 "9fada7c618c2293819746b7802d4b71c4c3615ec342be6b8c899e4551297b159" => :high_sierra
    sha256 "659b955035f9dbc317b7e1d74d7add56ae7cb874464545bc0ed5dd87cd144642" => :sierra
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
