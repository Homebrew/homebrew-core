class Bartycrouch < Formula
  desc "Incrementally update/translate your Strings files"
  homepage "https://github.com/Flinesoft/BartyCrouch"
  url "https://github.com/Flinesoft/BartyCrouch.git",
      tag:      "4.4.0",
      revision: "ac593d4fe3cb895944c1e67fa76046fb925733b6"
  license "MIT"
  head "https://github.com/Flinesoft/BartyCrouch.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "bb05255e27f2f4f8248374e390aac3c0f721b328ca8afd137f9f0aac17fd7e30" => :big_sur
    sha256 "c4425d05d4901ffab03c87991cf6af51efe85f7382c22eb1517b22f2f466ae0e" => :arm64_big_sur
    sha256 "71c4a6bf3106632f4cc5191a473d4dad66f2b86090fe52548a29b4775517b67e" => :catalina
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
