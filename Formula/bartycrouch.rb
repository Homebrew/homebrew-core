class Bartycrouch < Formula
  desc "Incrementally update/translate your Strings files"
  homepage "https://github.com/Flinesoft/BartyCrouch"
  url "https://github.com/Flinesoft/BartyCrouch.git",
      tag:      "4.10.2",
      revision: "8e12d831b2cb84c05c94a715815139e76f6a7b64"
  license "MIT"
  head "https://github.com/Flinesoft/BartyCrouch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cc3772fc61860a1a5f0013f9b7cfc214545dc7815e0759df68c3764885327ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22c833293a3638f2fc037b8d3acde3d9470422bcd18f7d932f048f3f56d2b88f"
    sha256 cellar: :any_skip_relocation, monterey:       "7fd5de567eda72492d0ad8488c76530a9e1ebc3770710ecb17ba2047310da247"
    sha256 cellar: :any_skip_relocation, big_sur:        "97f91089d2c485d33fa7becac46b1f5d9d102da5c9c58233d2a2ca85524eaab5"
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
