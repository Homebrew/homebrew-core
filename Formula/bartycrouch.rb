class Bartycrouch < Formula
  desc "Incrementally update/translate your Strings files"
  homepage "https://github.com/FlineDev/BartyCrouch"
  url "https://github.com/FlineDev/BartyCrouch.git",
      tag:      "4.13.0",
      revision: "36cc46399abe717986cda40ccd6d6eb34c6ff70d"
  license "MIT"
  head "https://github.com/FlineDev/BartyCrouch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd2e879cff394c1e6f7e9ad68c798e0cabdf3f624f99eb8e308f6d9d4d11b782"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "451f872bb60d12f471624c23dad49f040abfb23d0cc4eecd6f8970e59772460f"
    sha256 cellar: :any_skip_relocation, ventura:        "b476e74851ac08523154626d083509439a74a66b361b610236a4e42423fe8e3f"
    sha256 cellar: :any_skip_relocation, monterey:       "f2860b77f98f794025464a34cf1a565c8991336850d9f88cd8b5c57d3498ab3a"
  end

  depends_on xcode: ["14.0", :build]
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
