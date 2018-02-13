class Mrboom < Formula
  desc "Eight player Bomberman clone"
  homepage "http://mrboom.mumblecore.org/"
  url "https://github.com/Javanaise/mrboom-libretro/archive/4.2.tar.gz"
  sha256 "175badca208e27a60902af8c3637b3154d56941d7311e02527208c014e51af49"

  bottle do
    cellar :any
    sha256 "9c607fc727dbbc6402f1b09ab04de2a23352f1a4a6e5ed18046fbbe0df28629c" => :high_sierra
    sha256 "a01e3a1b77a9da87a7d64cf97f03e963187199367848ec1f5feeef21e476ab5b" => :sierra
    sha256 "d7133bd954fd02f47f24aa516e9c9b442092d20a3600c7544bec02085fd3728e" => :el_capitan
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
