class Mrboom < Formula
  desc "Eight player Bomberman clone"
  homepage "http://mrboom.mumblecore.org/"
  url "https://github.com/Javanaise/mrboom-libretro/releases/download/5.2/MrBoom-src-5.2.454d614.tar.gz"
  version "5.2"
  sha256 "50e4fe4bc74b23ac441499c756c4575dfe9faab9e787a3ab942a856ac63cf10d"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90b91f583d2e1e4a613ac864ca3fa48465057d16810a5077013c8d93bd7b62a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd5b5ec729889a0abe7b4c97a4ebbed82fe36d9e85a745bc59bfb32994198dac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8b8a1256014093b7946f4bb1dfefc7f435ba8a0e4884cd2378a90879b88a8d6"
    sha256 cellar: :any_skip_relocation, ventura:        "a0fd60e4cfeaae4d0858f0135ac4d08fc929b7f93909e0b3f7f3113ced889eff"
    sha256 cellar: :any_skip_relocation, monterey:       "b6d0d0f72bb83338b61a8c94a3e4072f37e909aa000ce52f4731c5e2b2973225"
    sha256 cellar: :any_skip_relocation, big_sur:        "c646553ede84d787e4d1b356a6d4e22139e6eb451a772a7e3e605bbed034bb6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57b9aa451a11a810ecef7586e680a2a6ade3da9546e60f704bc450c506f4d2d9"
  end

  depends_on "cmake" => :build
  depends_on "libmodplug"
  depends_on "minizip"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

  # Remove in next release
  # Fixes: common.cpp:115:10: fatal error: 'SDL_mixer.h' file not found
  patch do
    url "https://github.com/Javanaise/mrboom-libretro/commit/d483c2dc308ddaf831fb81bff965a1bca266b7c8.patch?full_index=1"
    sha256 "573f11c68b97190398f7f0bcb3338c6f387bf4be39e4fbd3896278b611d0cf59"
  end

  def install
    system "make", "mrboom", "LIBSDL2=1"
    system "make", "install", "PREFIX=#{prefix}", "MANDIR=share/man/man6"
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
