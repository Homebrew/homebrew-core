class Bartycrouch < Formula
  desc "Incrementally update your Strings files"
  homepage "https://github.com/Flinesoft/BartyCrouch"
  url "https://github.com/Flinesoft/BartyCrouch/archive/3.10.0.tar.gz"
  sha256 "86b84d7dbb9c0d48035c3043085b285a6323bed0fb62be1c2e8581ffc1a376af"

  bottle do
    cellar :any_skip_relocation
    sha256 "947edaa77499134d90dd8f39546a9334a1f15021ea91fca80da7dfca9323842b" => :high_sierra
    sha256 "eedcf2daf8f16e0f54c3e335758a377b5f92b061d4765aebdaee61030e56ab49" => :sierra
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
