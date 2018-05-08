class Bartycrouch < Formula
  desc "Incrementally update your Strings files"
  homepage "https://github.com/Flinesoft/BartyCrouch"
  url "https://github.com/Flinesoft/BartyCrouch/archive/3.12.1.tar.gz"
  sha256 "5c57aa114dfe2f9e8a91eb44685fa934dcad9a9b2a1c7255eeea520a6398a867"

  bottle do
    cellar :any_skip_relocation
    sha256 "480511fd7cbb50613bae01ab7024e45b814c95e3a4de2c5edbaaea295f8b9395" => :high_sierra
    sha256 "bd731dd092bb8ab15ab65650aa43a29234dfb48cfecdec8c2f6ac7e2927c2104" => :sierra
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
