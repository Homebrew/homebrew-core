class Bartycrouch < Formula
  desc "Incrementally update/translate your Strings files"
  homepage "https://github.com/FlineDev/BartyCrouch"
  url "https://github.com/FlineDev/BartyCrouch.git",
      tag:      "4.11.0",
      revision: "31c4cb250caae44dc3ab62c84becd3a85e55e8ad"
  license "MIT"
  head "https://github.com/FlineDev/BartyCrouch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c7ce850d5c1cc49da218324e7f9fea5720fda9c5a84043fadf47afb53838233"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e7a2f682e92d36b55d7af5169bcf78abd688475083550ab785bf2c9277ad438"
    sha256 cellar: :any_skip_relocation, monterey:       "296152c7b9ece6d199d04f569293b610c4594eb7a85fc34b80948e7022d33a65"
    sha256 cellar: :any_skip_relocation, big_sur:        "91e75b3257969acc5a38e0bff550fdfea6f8b8d54bed52443b88b32451be0512"
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
