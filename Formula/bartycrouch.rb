class Bartycrouch < Formula
  desc "Incrementally update/translate your Strings files"
  homepage "https://github.com/Flinesoft/BartyCrouch"
  url "https://github.com/Flinesoft/BartyCrouch.git",
      tag:      "4.6.0",
      revision: "771a4aeaab1cf262f0af51811379aaeea675e3cc"
  license "MIT"
  head "https://github.com/Flinesoft/BartyCrouch.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5ac9b15cd854432a11e43d2e73bafc0146a06107d62c6b8337a407ebc02614ff"
    sha256 cellar: :any_skip_relocation, big_sur:       "3573c8b0ae2893f825e5979a9f907be682735e29be39d2a3f69e7d6e0374332c"
    sha256 cellar: :any_skip_relocation, catalina:      "c51eed14bfc9048dfbe4bdf6a2fd49c35b3a4a5f9f2c4a187c6e5a04269c44ca"
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
