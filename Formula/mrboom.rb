class Mrboom < Formula
  desc "Eight player Bomberman clone"
  homepage "http://mrboom.mumblecore.org/"
  url "https://github.com/Javanaise/mrboom-libretro/archive/3.9.tar.gz"
  sha256 "166593ceed047464650b2de3c377c3cac1c9e3d807abe374e03b901f8ed6ab6e"

  bottle do
    cellar :any
    sha256 "c90ac297157ea0ef5b20602c4b72d880c0510c581ec4b27cf933aaece3fc3d73" => :high_sierra
    sha256 "be0b87327561ee9744c20f82ed7a75e0e009e19772018c1930a195ac8b291fc7" => :sierra
    sha256 "45f3fa69504692270ad5f7e5bd50b03132b37d558d77a2e0d4bd27f2f6f7d420" => :el_capitan
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
