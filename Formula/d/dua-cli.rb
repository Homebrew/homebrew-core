class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.30.0.tar.gz"
  sha256 "8c5b0b30d9f2a5d7fef5621d8dd38690a4394d428206bb0473c2b48234d43331"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b528c9dffdcbc18ae5049aef0673938dc00e69367d30105ce86e558cb191479"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ac15f4abc82f154d03f8e384da9ce1af37e36f71f84136bf157c92b650b8c5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa3b62f2e9141eb656bc8359d59223c9b317d681759d15f7348523c733900ef9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4dadef8ebfb0cefe0b24968ed83b472738f481c5f4ff80eb9ed7600d9b3f7d6"
    sha256 cellar: :any_skip_relocation, ventura:       "f67e8a8625f1400c26d60ff0b98b895d2054960c1fe4e5d8ec21d5cd0057cc4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29d03a6054e45da5e5e48b6e76faf2597990cfd19e8e51be57b30e808d3a50f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "572a6d480fa4c74ebdaf6e22138573d94f2169e49717b4441e9384e3a0e14c45"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test that usage is correct for these 2 files.
    (testpath/"empty.txt").write("")
    (testpath/"file.txt").write("01")

    expected = %r{
      \e\[32m\s*0\s*B\e\[39m\ #{testpath}/empty.txt\n
      \e\[32m\s*2\s*B\e\[39m\ #{testpath}/file.txt\n
      \e\[32m\s*2\s*B\e\[39m\ total\n
    }x
    assert_match expected, shell_output("#{bin}/dua -A #{testpath}/*.txt")
  end
end
