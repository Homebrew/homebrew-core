class Bartycrouch < Formula
  desc "Incrementally update your Strings files."
  homepage "https://github.com/Flinesoft/BartyCrouch"
  url "https://github.com/Flinesoft/BartyCrouch/archive/3.8.0.tar.gz"
  sha256 "8180b7f016ad9dd34f9fd022c94bf476e8648aa608b4d5b928519bdf0e940a76"

  depends_on :xcode => ["8.0", :build]

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
    (testpath/"Test.swift").write <<-EOS.undent
    import Foundation

    class Test {
      func test() {
          NSLocalizedString("test", comment: "")
      }
    }
    EOS

    (testpath/"en.lproj/Localizable.strings").write <<-EOS.undent
    /* No comment provided by engineer. */
    "oldKey" = "Some translation";
    EOS

    system bin/"bartycrouch", "code", "-p", testpath, "-l", testpath, "-a"
    assert_match /"oldKey" = "/, File.read("en.lproj/Localizable.strings")
    assert_match /"test" = "/, File.read("en.lproj/Localizable.strings")
  end
end
