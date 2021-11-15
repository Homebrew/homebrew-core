class Bartycrouch < Formula
  desc "Incrementally update/translate your Strings files"
  homepage "https://github.com/Flinesoft/BartyCrouch"
  url "https://github.com/Flinesoft/BartyCrouch.git",
      tag:      "4.8.0",
      revision: "e2cd0f35fb13b596196091a9ae8de67857e3479a"
  license "MIT"
  head "https://github.com/Flinesoft/BartyCrouch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9be082e513bf752284882fcb6c7bf6187b3b5f0bcbcd786ab51d62ba2a033e14"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb287ef35120a2ce095f1fcd1f0c434ac3934bfd3f13edbdc0bd99ed8934765e"
    sha256 cellar: :any_skip_relocation, monterey:       "79f5493893cfc7372fcd78a139e57af452432420129ee5d4171bd773ec67db5e"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ca80eae1448147e3fb61233845ec77329a2ac031896f0cc260a24fae589c1b4"
  end

  depends_on xcode: ["12.5", :build]
  depends_on :macos

  def install
    system "make", "install", "prefix=#{prefix}"
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
