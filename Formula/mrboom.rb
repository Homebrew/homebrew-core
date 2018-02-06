class Mrboom < Formula
  desc "Eight player Bomberman clone"
  homepage "http://mrboom.mumblecore.org/"
  url "https://github.com/Javanaise/mrboom-libretro/archive/4.2.tar.gz"
  sha256 "175badca208e27a60902af8c3637b3154d56941d7311e02527208c014e51af49"

  bottle do
    cellar :any
    sha256 "0639f07ac18a65cdea793a5f7041fbe6f9760a00a149dc3d6b6be19235b24c16" => :high_sierra
    sha256 "9850e96338eea22b8c1bcdd322edf9fd356afe5875e211f5c132e069330b8d4c" => :sierra
    sha256 "8fbd06b443e54465ebb70354d4790b5b4732443add94f8de0f2ab4790e0157c5" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "libmodplug"
  depends_on "minizip"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

  def install
    system "make", "mrboom", "LIBSDL2=1"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    require "pty"
    PTY.spawn(bin/"mrboom", "-m") do |r, _w, pid|
      begin
        sleep 1
        Process.kill "SIGINT", pid
        assert_match "monster", r.read
      ensure
        Process.wait pid
      end
    end
  end
end
