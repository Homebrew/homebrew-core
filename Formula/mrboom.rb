class Mrboom < Formula
  desc "Eight player Bomberman clone"
  homepage "http://mrboom.mumblecore.org/"
  url "https://github.com/Javanaise/mrboom-libretro/archive/4.9.tar.gz"
  sha256 "062cf1f91364d2d6ea717e92304ca163cfba5d14b30bb440ee118d1b8e10328d"
  license "MIT"

  bottle do
    cellar :any
    sha256 "d85ec4ab953ce62ec26b3f632943f4155c7b4b06a6c7bfeec4af334bd3453c5d" => :catalina
    sha256 "8a4663dd80ed90899b51c5a568b1a8330b06441eba93cfa70e773514dbba4b2d" => :mojave
    sha256 "a3c07658f4050be94c37c341f262b7c82a808dd696f349841aa0e83b07eaf8e7" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libmodplug"
  depends_on "minizip"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

  # fix Makefile issue, remove in next release
  patch do
    url "https://github.com/Javanaise/mrboom-libretro/commit/c777f1059c9a4b3fcefe6e2a19cfe9f81a13740b.diff?full_index=1"
    sha256 "19f469ccde5f1a9bc45fa440fd4cbfd294947f17b191f299822db17de66a5a23"
  end

  def install
    system "make", "mrboom", "LIBSDL2=1"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    require "pty"
    require "expect"
    require "timeout"
    PTY.spawn(bin/"mrboom", "-m", "-f 0", "-z") do |r, _w, pid|
      sleep 1
      Process.kill "SIGINT", pid
      assert_match "monster", r.expect(/monster/, 10)[0]
    ensure
      begin
        Timeout.timeout(10) do
          Process.wait pid
        end
      rescue Timeout::Error
        Process.kill "KILL", pid
      end
    end
  end
end
