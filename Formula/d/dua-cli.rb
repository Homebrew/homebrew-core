class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.32.0.tar.gz"
  sha256 "b0195e4ea892b4f48882fec4371c83b6f4d3e8243556c38ed04bd5efe8dad59c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47013d1b165bf6f501a07957176c342212409f0e5cf0533246820dd9161de5cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "276b1f8f101b8edf5ef5cc4c16626e66cc55ce80831a969ac571b8f7ddd08e92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ef6e048892a928eba61ac333ce8e7ad85008ab6833f10e71c39af40b8c8bccb"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d3fae69e1721a21dc412458a4e9c6f6ed543434fbcdf648f93265e2d20ca06e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e01d10b139d478178dada0579705776da6082af6cc8502cc5281827dfbfba5ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e62448252245e413148f521585fccc550ce791289f142b84104f89ab6e23ea2f"
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
