class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.2.3.tar.gz"
  sha256 "2342646d140d3db30d1ba4708cd5ae05f5b02d62fc69e5491adeed7808750220"
  license "MIT"
  head "https://github.com/Canop/broot.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6e8c0d00df5c08329a73c8cc9848b7c4df5173f28eea234fc716265fc1f3da4f"
    sha256 cellar: :any_skip_relocation, big_sur:       "79279e07716ee4083a47674ef677742234dd4afffedfc8c55ee9fe5ecd74e5fa"
    sha256 cellar: :any_skip_relocation, catalina:      "98fe6c627c7d1763a6061b9d2efbe5340fe247c701a6727b18de57a9045871fd"
    sha256 cellar: :any_skip_relocation, mojave:        "f94148569aaedd1c9a4c0f92fe1777f864b3f894aa448e160be10fc1f8b02957"
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
