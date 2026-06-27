class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.37.0.tar.gz"
  sha256 "9373b85fbf626afe7de27d209b1ed9775825b89b211c8480255ac38b1e3e270c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e66bdf22bf1c9d21c05745ad8b011403fc1b298b842f4da13a0118c80b8feba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7e4d9ec2de2153e0b0139d123ca2cd10d5c54f2cb5fe540e1d528d94a7867d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "045719a69d61b808f9c7490c06c5eea8d9da0ca360b6f7c8eb63a974910efa89"
    sha256 cellar: :any_skip_relocation, sonoma:        "b90a40d28919c60b19ff266357bcec409eacf5c08e2358b8eb49409b9e6cced3"
    sha256 cellar: :any,                 arm64_linux:   "a6b710b32c508c402a425744ef4e832c38ed020fe082e484838d163a8bdfc8de"
    sha256 cellar: :any,                 x86_64_linux:  "24a5e0ff4fb2cda02556dfec2cca265389de8723810ccdb6289cf951e7c9c2d7"
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
