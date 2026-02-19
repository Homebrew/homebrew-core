class Bartycrouch < Formula
  desc "Incrementally update/translate your Strings files"
  homepage "https://github.com/FlineDev/BartyCrouch"
  url "https://github.com/FlineDev/BartyCrouch.git",
      tag:      "4.15.1",
      revision: "fe88110ab0af3d1281138b63159e20a7450383fa"
  license "MIT"
  head "https://github.com/FlineDev/BartyCrouch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "46fbbd53f6f604e0b12914220924a0dffbc030707b8079b488716e9cc3d97fe4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e1c38b26cfa121cc550ed3a82c6ec5838855f86afa694b31ae6ad33463857880"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eaa1ce531757276cd36316e1d689fea793b203923abddc935c78237551a6e8ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b13d54cac22da186bd607c75403d684dd1ba9210a62f5cbbe310a204761df0db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04e1c952b93b649d10bc8d21393d85f3bbf34f6367c8c45d397e35cb7078f358"
    sha256 cellar: :any_skip_relocation, sonoma:         "04e8787865027a86682e3f371d346c8cdf2fada6d9a8143d47e805059bfef416"
    sha256 cellar: :any_skip_relocation, ventura:        "a96c215d738ffedc43b770955b434a74b2ebb7ee085d25636a29276628481f90"
    sha256 cellar: :any_skip_relocation, monterey:       "0dc9b2657b7071f05f5d4cd6e0563add579632de61ee1fc70135c9182064591a"
  end

  depends_on xcode: ["14.0", :build]
  depends_on :macos

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"Test.swift").write <<~SWIFT
      import Foundation

      class Test {
        func test() {
            NSLocalizedString("test", comment: "")
        }
      }
    SWIFT

    (testpath/"en.lproj/Localizable.strings").write <<~EOS
      /* No comment provided by engineer. */
      "oldKey" = "Some translation";
    EOS

    system bin/"bartycrouch", "update"
    assert_match '"oldKey" = "', File.read("en.lproj/Localizable.strings")
    assert_match '"test" = "', File.read("en.lproj/Localizable.strings")
  end
end
