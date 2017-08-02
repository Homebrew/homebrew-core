class Bartycrouch < Formula
  desc "Incrementally update your Strings files."
  homepage "https://github.com/Flinesoft/BartyCrouch"
  url "https://github.com/Flinesoft/BartyCrouch/archive/3.8.1.tar.gz"
  sha256 "4ff72004ad7f992da1175dbabe1e37cf30f60a31a67899c71f88018d40e83aaa"

  bottle do
    cellar :any_skip_relocation
    sha256 "b11ab8ba03c1b3fbc0d1a4f00a239e913114bbdd9a2a4f3d60a152718807c426" => :sierra
    sha256 "5767a6f7eb837fdf6922fd94f11994c390f6d293919a761b575cef457a683022" => :el_capitan
  end

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
