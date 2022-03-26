class Bartycrouch < Formula
  desc "Incrementally update/translate your Strings files"
  homepage "https://github.com/Flinesoft/BartyCrouch"
  url "https://github.com/Flinesoft/BartyCrouch.git",
      tag:      "4.10.2",
      revision: "8e12d831b2cb84c05c94a715815139e76f6a7b64"
  license "MIT"
  head "https://github.com/Flinesoft/BartyCrouch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70be38e64705f2ce9d8c17a3726f5bb8985107442968b452a9c20896d5a020e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01b027a64112756fb762a39e689ec55fee526c0521fb6847447851f6728e20e2"
    sha256 cellar: :any_skip_relocation, monterey:       "739e9a0ba1d6d4482d935b8e6ec01aa36791fc5b72bb8e4319f4a7239308c2c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "38fa4742fe695b7b88ace488d89941c83027f17dca38c4dd871e0491f2a9ef18"
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
