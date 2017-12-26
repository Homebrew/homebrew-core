class Nnn < Formula
  desc "Free, fast, friendly file browser"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v1.6.tar.gz"
  sha256 "e8b10a3b9847ba7ad3317f608691aaebcdaf2b67219d732f7a5d468221d3e83e"

  bottle do
    cellar :any
    sha256 "bb763df644735027c3461bb423b381418266ec70eaac20d457be87445b1d94aa" => :high_sierra
    sha256 "bfb3e43e95ffe9ba3e601ad02a7aa4f1ecb313a472b22b415288c00e3d740678" => :sierra
    sha256 "813fbdb127710d374d7121f380ac58e4f49cf044495529981d1b99ef98cba0a6" => :el_capitan
  end

  depends_on "readline"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Testing this curses app requires a pty
    require "pty"
    PTY.spawn(bin/"nnn") do |r, w, _pid|
      w.write "q"
      assert_match testpath.realpath.to_s, r.read
    end
  end
end
