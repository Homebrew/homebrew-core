class Bartycrouch < Formula
  desc "Incrementally update your Strings files"
  homepage "https://github.com/Flinesoft/BartyCrouch"
  url "https://github.com/Flinesoft/BartyCrouch/archive/3.9.1.tar.gz"
  sha256 "c7f5b6dcbe6598cee77c2e803f8429043838c05bd67007b26ea3aff0531502e2"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ce64430d86c94e00f952b9e16eab5b47062641402d5c9eac8cae6aba94228a35" => :high_sierra
    sha256 "8902cfb8b3ef9fd43662c44f4fbc1d761afeaf502878c9a7677987dae291042c" => :sierra
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
