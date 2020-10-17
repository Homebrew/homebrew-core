class Mrboom < Formula
  desc "Eight player Bomberman clone"
  homepage "http://mrboom.mumblecore.org/"
  url "https://github.com/Javanaise/mrboom-libretro/archive/5.0.tar.gz"
  sha256 "71af5a47ca5a8972598fe388b653120315bd2e7e05e99a3ee68637c2f74688fc"
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
