class Mrboom < Formula
  desc "Eight player Bomberman clone"
  homepage "http://mrboom.mumblecore.org/"
  url "https://github.com/Javanaise/mrboom-libretro/archive/4.5.tar.gz"
  sha256 "3f1c94a9e25b0f7cc3be021513b15ab73580965317671ac413ef9442442ce84e"

  bottle do
    cellar :any
    sha256 "08a0223ee14790b53bbf08e26d68ce89822143148ff1f590464d2fc6f9087b60" => :high_sierra
    sha256 "084318a953b9733b399f6cc282ebf876975b1d1f8eb5cf889af472690cafc092" => :sierra
    sha256 "cd3b7929cc51c07b1c91f01b87253423191fcd5ba5c9f4486ada846f13808d52" => :el_capitan
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
