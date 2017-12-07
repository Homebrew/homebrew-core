class Mrboom < Formula
  desc "Eight player Bomberman clone"
  homepage "http://mrboom.mumblecore.org/"
  url "https://github.com/Javanaise/mrboom-libretro/archive/4.1.tar.gz"
  sha256 "97fde7a2ce7c1e9de7691d2ebd9987c61feaa6997a449c45320db31f496996c8"

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
