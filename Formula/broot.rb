class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot"
  url "https://github.com/Canop/broot/archive/v0.13.6.tar.gz"
  sha256 "f28eea78bba1660ecdbdb9ebac8e215b7523b94f7d490d69d8022df44eacec3c"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a9854899ce658d45148ce8f194d9bdda84799a7d552e4d264a0118b49ea707d4" => :catalina
    sha256 "221d7097a8d1f731c10a7b498d76886e5b46238ce9b4fe94f38deafe1247b0d4" => :mojave
    sha256 "619d04bce458d7adccdddfe222fa0bfc600556337a870def65ab4e7406a43d99" => :high_sierra
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
