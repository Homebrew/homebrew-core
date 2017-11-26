class Mrboom < Formula
  desc "Eight player Bomberman clone"
  homepage "http://mrboom.mumblecore.org/"
  url "https://github.com/Javanaise/mrboom-libretro/archive/3.9.tar.gz"
  sha256 "166593ceed047464650b2de3c377c3cac1c9e3d807abe374e03b901f8ed6ab6e"

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
