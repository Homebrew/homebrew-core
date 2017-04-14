class Nnn < Formula
  desc "Free, fast, friendly file browser"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v1.0.tar.gz"
  sha256 "032d8cdcaa237f4392cc0ab335b984f2107c458c7d1ffec35a4abfe3aa0e5486"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    touch "foobar"
    # Testing this curses app requires a pty
    require "pty"
    PTY.spawn(bin/"nnn") do |r, w, _pid|
      w.write "q"
      assert_match "foobar", r.read
    end
  end
end
