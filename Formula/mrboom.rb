class Mrboom < Formula
  desc "Eight player Bomberman clone"
  homepage "http://mrboom.mumblecore.org/"
  url "https://github.com/Javanaise/mrboom-libretro/archive/4.7.tar.gz"
  sha256 "5ebf8bbec292a5e9b4cb337695e0d3baa3b777f99d1aaf011c937c62ef958e3a"

  bottle do
    cellar :any
    sha256 "fc10a261927a560776acad38740577b232f87470dc2a225cd973e9c85ee91a17" => :mojave
    sha256 "6b6fc5f88179c60f448e240744d5759410ad986c1bbae54fa180b187d88086ac" => :high_sierra
    sha256 "1e0f68ba7b12bc2bb879f99d90ec990c6d493c623a7fc787671e80dd8bac6884" => :sierra
    sha256 "d8169f04a040dee4151b850c0bf087146f3401110ac10e7651f2b0986ea6a504" => :el_capitan
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
