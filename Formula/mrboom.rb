class Mrboom < Formula
  desc "Eight player Bomberman clone"
  homepage "http://mrboom.mumblecore.org/"
  url "https://github.com/Javanaise/mrboom-libretro/releases/download/5.2/MrBoom-src-5.2.454d614.tar.gz"
  version "5.2"
  sha256 "50e4fe4bc74b23ac441499c756c4575dfe9faab9e787a3ab942a856ac63cf10d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "cf2c1633672145fe98dcc7ed89e75b1282081941d8def655b84967c5d2a80ea8"
    sha256 cellar: :any,                 arm64_big_sur:  "90484ee7a62a29aa82242664b917340def45c3b999a7d21197ac10e020617194"
    sha256 cellar: :any,                 monterey:       "fd4bf9a47d15da1e296433860388dd78cbc6d46d036a0145eb36c651693fce25"
    sha256 cellar: :any,                 big_sur:        "904cd506e99c6269809fe4c593263de7cc1f0746fe0c5b5180aa63ef522ca212"
    sha256 cellar: :any,                 catalina:       "7fc60e5a37d093f2311b797c5822dbeb098cdf47c038c808496973d29f563f2c"
    sha256 cellar: :any,                 mojave:         "262fab23ed3b5a3b80948ae4fb4eca1c0c0cad04220a031a731905d812aebaae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb5d8f528c43dfa0eb5970a5ba8e0b98d4db662f903ec2d62751d98ef013f780"
  end

  depends_on "cmake" => :build
  depends_on "libmodplug"
  depends_on "minizip"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

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
