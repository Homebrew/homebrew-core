class Bartycrouch < Formula
  desc "Incrementally update/translate your Strings files"
  homepage "https://github.com/Flinesoft/BartyCrouch"
  url "https://github.com/Flinesoft/BartyCrouch.git",
      tag:      "4.4.1",
      revision: "d0ea3568044e2348e5fa87b9fdbc9254561039e2"
  license "MIT"
  head "https://github.com/Flinesoft/BartyCrouch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "635a9fff91e57290f013826f3b102fd1e639ed4d8dd9f2a5fc84ee3ee86b3383" => :big_sur
    sha256 "290d66a6a7164de7c459553fcaaf6ffdc2c8e48673d4536626aac4a644a18107" => :arm64_big_sur
    sha256 "a403e05eef2353f041f499275a0ebcea1fc9381bea71b9205227a319ed5547c9" => :catalina
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
