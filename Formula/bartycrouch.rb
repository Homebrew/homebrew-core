class Bartycrouch < Formula
  desc "Incrementally update/translate your Strings files"
  homepage "https://github.com/Flinesoft/BartyCrouch"
  url "https://github.com/Flinesoft/BartyCrouch.git",
      tag:      "4.5.0",
      revision: "34ca469548e5ed8c39ddc394683b5cfcd510d866"
  license "MIT"
  head "https://github.com/Flinesoft/BartyCrouch.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "32a73b5f6efe8401e1aade10a2ac16b0d1116ab9b3c7e2fcc4cadb9dee26cc64"
    sha256 cellar: :any_skip_relocation, big_sur:       "5b64f40f1dc594b244c0a68eec60332f0bb10b59218a7086832cf8264f958f8c"
    sha256 cellar: :any_skip_relocation, catalina:      "68b7b0654ff7e0d4d46713d245e180dd547559b8e6065ad0ce2bd0687d8fe4ee"
  end

  depends_on xcode: ["12.0", :build]
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
