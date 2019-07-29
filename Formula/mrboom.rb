class Mrboom < Formula
  desc "Eight player Bomberman clone"
  homepage "http://mrboom.mumblecore.org/"
  url "https://github.com/Javanaise/mrboom-libretro/archive/4.7.tar.gz"
  sha256 "5ebf8bbec292a5e9b4cb337695e0d3baa3b777f99d1aaf011c937c62ef958e3a"

  bottle do
    cellar :any
    sha256 "06483d8f9be743f76eddcf26c222831fc082996539e2e5e6a6add33fc55af11b" => :mojave
    sha256 "b68760e7638ce0b3d0fc342a9f6a85d07935ab000bd3c11a7dde71067f3c8c68" => :high_sierra
    sha256 "214a0f035befd1973788023b52ea8a21d7df076b2c50bf7c5445ac418e930d8e" => :sierra
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
