class Bartycrouch < Formula
  desc "Incrementally update your Strings files."
  homepage "https://github.com/Flinesoft/BartyCrouch"
  url "https://github.com/Flinesoft/BartyCrouch/archive/3.9.0.tar.gz"
  sha256 "8dd474d6b559bcb6e3d207a4acb278f59f23bdc62968aef1310bc7d767c789bc"

  bottle do
    cellar :any
    sha256 "0ad0342a214df7d39bd914fa90b21fdbde5b105f3b659b7efa6c93d827ee875d" => :high_sierra
    sha256 "2f61b1e0bcd29fe6de71ab08768b35e73438494afa489487b6539ccae15dd3ad" => :sierra
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
