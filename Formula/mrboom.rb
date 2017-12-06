class Mrboom < Formula
  desc "Eight player Bomberman clone"
  homepage "http://mrboom.mumblecore.org/"
  url "https://github.com/Javanaise/mrboom-libretro/archive/4.0.tar.gz"
  sha256 "d7475412d2ef4726de4516f145d865e0e25d4a36f91be2621c2b512cca5e8bba"

  bottle do
    cellar :any
    sha256 "373eb4c1717cf4fb0208a496693eadbc9965183c861d39c2f814cfc2b1c04d83" => :high_sierra
    sha256 "23adf329d15f5856a90beeacbbe91478295d7c8e3140253a7b73b37dac8159ca" => :sierra
    sha256 "1179db24ff0acf8bc5d7bf44727fa8c80142d9a620cf757d33c01c97ec8906c5" => :el_capitan
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
