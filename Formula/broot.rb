class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.2.4.tar.gz"
  sha256 "c0122bffb9fb92f4050a5216a27b0c86b58194e33a62b19e1e3128171b1fde05"
  license "MIT"
  head "https://github.com/Canop/broot.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ab0410c31bd630ef4120236fb3ee43ad868387b6e3f35561da2b03ab852c6367"
    sha256 cellar: :any_skip_relocation, big_sur:       "407497deb4d27d5008421c3d096606f24f0e137c00f78d590766d528b8191df3"
    sha256 cellar: :any_skip_relocation, catalina:      "1c0f1978be42f422ee84f084530588a291568e6744d01dc60b8574b1db75465f"
    sha256 cellar: :any_skip_relocation, mojave:        "87a851ebb2c87e706766df9a084ea8bd85e911020617186b6251621e29e90571"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "A tree explorer and a customizable launcher", shell_output("#{bin}/broot --help 2>&1")

    require "pty"
    require "io/console"
    PTY.spawn(bin/"broot", "--cmd", ":pt", "--no-style", "--out", testpath/"output.txt", err: :out) do |r, w, pid|
      r.winsize = [20, 80] # broot dependency termimad requires width > 2
      w.write "n\r"
      assert_match "New Configuration file written in", r.read
      Process.wait(pid)
    end
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
