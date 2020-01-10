class Mrboom < Formula
  desc "Eight player Bomberman clone"
  homepage "http://mrboom.mumblecore.org/"
  url "https://github.com/Javanaise/mrboom-libretro/archive/4.9.tar.gz"
  sha256 "062cf1f91364d2d6ea717e92304ca163cfba5d14b30bb440ee118d1b8e10328d"

  bottle do
    cellar :any
    sha256 "154f40d61ea23fa239392be94ebfa6387edc23693eb1be741da2857f749d3e30" => :catalina
    sha256 "4ba2c8e5e221b0caede7a888554151b21f66cf1dcb0a656b6f311f62f406a788" => :mojave
    sha256 "1508a8b273950f25e649b809a696a58b2fdc17a8cf13114ff117719d8bf1f95a" => :high_sierra
    sha256 "171552ccf311dddbcf124c8f17d424f10d54e48312dffdd8fc3b906e6c700e87" => :sierra
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
