class Bartycrouch < Formula
  desc "Incrementally update your Strings files."
  homepage "https://github.com/Flinesoft/BartyCrouch"
  url "https://github.com/Flinesoft/BartyCrouch/archive/3.8.1.tar.gz"
  sha256 "4ff72004ad7f992da1175dbabe1e37cf30f60a31a67899c71f88018d40e83aaa"

  bottle do
    cellar :any_skip_relocation
    sha256 "69ce157192d8a7464094978f151bffe5df81e27c9f813c74a0cebed9b5dd924c" => :sierra
    sha256 "d18ce7fd273cbf95e231983c613b1c4c4bc12b41353b5ad866b8e803e5653bf6" => :el_capitan
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
