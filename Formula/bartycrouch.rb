class Bartycrouch < Formula
  desc "Incrementally update/translate your Strings files"
  homepage "https://github.com/Flinesoft/BartyCrouch"
  url "https://github.com/Flinesoft/BartyCrouch.git",
      tag:      "4.7.0",
      revision: "c16b219d28ce27e57744dcf67adfde7a2912d78a"
  license "MIT"
  head "https://github.com/Flinesoft/BartyCrouch.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "26a99ff30f33322c929a0acab804cd9ddb14e2f588143c40e29b298e01681e29"
    sha256 cellar: :any_skip_relocation, big_sur:       "880745509a5a98931d23d0fa57e8647e3b44bdc33b0f5c8a3c3f40f26f5078c3"
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
