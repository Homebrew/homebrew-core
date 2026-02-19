class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.33.0.tar.gz"
  sha256 "32ecebfd555f09cbcfae415499d68de6023cc4f8eb4f249e54761e521d1ee553"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5490e6eb27e6010cdfaeb8bc96cf7340d9f609bb249849b0cd6f14861e25480b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1adaf7eb20c5685baeea0922904c98951a0e98b6623f247ae9a4ec204268bc0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3086463f8013099b1c478a4981ecbd1e8573b1b306301ed8d6935648ae8e64ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "00189b2c80e411064d4d4cff60e3b1da99518976ffd7fd921c2977a07ab9cfd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67ad8cda346bd50f2794d09357dbb7e920341ec461f39c3f12d95f8bd4cda767"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfa009bdbb9bab43eca4187739bdb6259c5218cfa6dcc207ad4fe0a504d8dfdd"
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
