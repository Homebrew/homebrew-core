class Bartycrouch < Formula
  desc "Incrementally update/translate your Strings files"
  homepage "https://github.com/Flinesoft/BartyCrouch"
  url "https://github.com/Flinesoft/BartyCrouch.git",
      tag:      "4.3.2",
      revision: "35b819cb7575583c74a4d13ca4a91d829d1b8a7c"
  license "MIT"
  head "https://github.com/Flinesoft/BartyCrouch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a9b173c9de755e9c45234e503c062748786d7f984749354a1ac4450ec37df6aa" => :big_sur
    sha256 "470964f2e3f481633f981acb9a32aec8fdfd51b4616f587b1a05319b5b4155b3" => :arm64_big_sur
    sha256 "aa2777a08e4d1a12340638678c4652b4ab5d5aa6f7db2917e7c907550d524119" => :catalina
  end

  depends_on xcode: ["12.0", :build]

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
    assert_match /"oldKey" = "/, File.read("en.lproj/Localizable.strings")
    assert_match /"test" = "/, File.read("en.lproj/Localizable.strings")
  end
end
