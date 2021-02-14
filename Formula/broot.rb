class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.2.4.tar.gz"
  sha256 "c0122bffb9fb92f4050a5216a27b0c86b58194e33a62b19e1e3128171b1fde05"
  license "MIT"
  head "https://github.com/Canop/broot.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "031cc1132c50f9e70e35c7e5c0e7bcd3d1e9d17879d33610c35888429bc0da92"
    sha256 cellar: :any_skip_relocation, big_sur:       "0eecb7b33ee8004c8ad6edafbd25a9ca753855a134f587e63a2e7e271fe11163"
    sha256 cellar: :any_skip_relocation, catalina:      "5b7f1ee374dbb2e73e652f17018c3f530403158613ad77942ca637455ef28187"
    sha256 cellar: :any_skip_relocation, mojave:        "43bcb4828239bcd6efb709418522121b3d725a8f87d037bcdd02d2cc90cacfc1"
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
