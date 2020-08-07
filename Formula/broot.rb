class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v0.19.4.tar.gz"
  sha256 "839f9a2808e35ae78b184310e4c6940908dca2dd117b02c50bf55e5322efd3e1"
  license "MIT"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "51765da79e0a88716e2016bce2d5d1fbe4d68c3e6a00cf88229896b1a2424316" => :catalina
    sha256 "181745c7eea44b754ce62848ad77a44fb1ebfd9678db5e93dfe47e472e3c8668" => :mojave
    sha256 "e81e73d43a0b1cb6e91ee0c2fb485f64853746d7499b3fb707dd3bf13ccddbc2" => :high_sierra
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
