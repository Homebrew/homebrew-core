class Mrboom < Formula
  desc "Eight player Bomberman clone"
  homepage "http://mrboom.mumblecore.org/"
  url "https://github.com/Javanaise/mrboom-libretro/archive/4.4.tar.gz"
  sha256 "90b528da7e606194670c25f4ad0f57be1c7f90650bf925f20820e0622f5f633b"

  bottle do
    cellar :any
    sha256 "7e67051cd7841c78e83a443f8ec8862298fa4c62bb3eab004d27207625d78cb0" => :high_sierra
    sha256 "801e79dcca5af34d065dc46e80978795bd19a687b1e436a75aca4ff6507ac7c1" => :sierra
    sha256 "6017c2d199f678f1884442489dc5148f3b95eab62e819fdf84071a49d7bd97cb" => :el_capitan
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
