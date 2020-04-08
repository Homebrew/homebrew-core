class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot"
  url "https://github.com/Canop/broot/archive/v0.13.6.tar.gz"
  sha256 "f28eea78bba1660ecdbdb9ebac8e215b7523b94f7d490d69d8022df44eacec3c"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "216a1b9357264285f92a3c956d804d2b86832056fc361512c840e5c87d7400c2" => :catalina
    sha256 "3b3fbcca5c76323b6ad9f05119fb2149f7d99742c8b69d7b023b700b8963eee1" => :mojave
    sha256 "e413f010ff344a8cc3d7bcd631ec9c2170f9f2c477bc8fe3d61dcadc15d94f3b" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_match "A tree explorer and a customizable launcher", shell_output("#{bin}/broot --help 2>&1")

    require "pty"
    require "io/console"
    PTY.spawn(bin/"broot", "--cmd", ":pt", "--no-style", "--out", testpath/"output.txt", :err => :out) do |r, w, pid|
      r.winsize = [20, 80] # broot dependency termimad requires width > 2
      w.write "n\r"
      assert_match "New Configuration file written in", r.read
      Process.wait(pid)
    end
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
