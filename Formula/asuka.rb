class Asuka < Formula
  desc "Gemini Project client written in Rust with NCurses"
  homepage "https://git.sr.ht/~julienxx/asuka"
  url "https://git.sr.ht/~julienxx/asuka/archive/0.8.0.tar.gz"
  sha256 "c06dc528b8588be4922a7b4357f8e9701b1646db0828ccfcad3a5be178d31582"

  bottle do
    cellar :any_skip_relocation
    sha256 "e822cdbdf7c6eeaefabde6c69853ed5acdab7b959d44feff9e5c6eb44ea4b75c" => :catalina
    sha256 "95691f54ea6f8e5e218ec152b0d9685a4a8f4d59075207a1f75958333a174410" => :mojave
    sha256 "422e2efe84c94e78b3f1ab4bf9928d594c83e09b8ad1e32aabf04b17c2b8bb8a" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "ncurses"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    input, _, wait_thr = Open3.popen2 "script -q screenlog.txt"
    input.puts "stty rows 80 cols 43"
    input.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/asuka"
    sleep 1
    input.putc "g"
    sleep 1
    input.puts "gemini://gemini.circumlunar.space"
    sleep 10
    input.putc "q"
    input.puts "exit"

    screenlog = (testpath/"screenlog.txt").read
    assert_match /# Project Gemini/, screenlog
    assert_match /Gemini is a new internet protocol/, screenlog
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end
