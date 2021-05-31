class Mrboom < Formula
  desc "Eight player Bomberman clone"
  homepage "http://mrboom.mumblecore.org/"
  url "https://github.com/Javanaise/mrboom-libretro/releases/download/5.2/MrBoom-src-5.2.454d614.tar.gz"
  version "5.2"
  sha256 "50e4fe4bc74b23ac441499c756c4575dfe9faab9e787a3ab942a856ac63cf10d"
  license "MIT"

  bottle do
    sha256 cellar: :any, catalina:    "6531998d0edc841a0070135bad1f06910c2b7bc039db508562dedc0bcc054502"
    sha256 cellar: :any, mojave:      "ccbe19edffde88813ff3ab4657f449ccbb366d536b3b52cc81fde1a1959bd0da"
    sha256 cellar: :any, high_sierra: "d50267a32f6fd8e9d181c0d857f2b04343702cca3d540bb14f033ee66fcf589f"
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
    require "expect"
    require "timeout"
    PTY.spawn(bin/"mrboom", "-m", "-f 0", "-z") do |r, _w, pid|
      sleep 15
      Process.kill "SIGINT", pid
      assert_match "monster", r.expect(/monster/, 10)[0]
    ensure
      begin
        Timeout.timeout(30) do
          Process.wait pid
        end
      rescue Timeout::Error
        Process.kill "KILL", pid
      end
    end
  end
end
