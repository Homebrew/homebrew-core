class Asuka < Formula
  desc "Gemini Project client written in Rust with NCurses"
  homepage "https://git.sr.ht/~julienxx/asuka"
  url "https://git.sr.ht/~julienxx/asuka/archive/0.8.0.tar.gz"
  sha256 "c06dc528b8588be4922a7b4357f8e9701b1646db0828ccfcad3a5be178d31582"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3ff6b3aa52148d1468bf6d59d63302c76069dbad963f8722f7e87e53342c40a4" => :catalina
    sha256 "0042a8cf343f444996bcd95e6b279e891e360f309bea3901a02b983833f48dc8" => :mojave
    sha256 "174f726dde72bd1ef2a31a0c4b49728338c60521b4ca2c8c3364ceb6f54a0b4d" => :high_sierra
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
