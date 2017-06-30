class Mrboom < Formula
  desc "Mr.Boom is an 8 players Bomberman clone"
  homepage "http://mrboom.mumblecore.org"
  url "https://github.com/Javanaise/mrboom-libretro/archive/3.3.tar.gz"
  sha256 "b96dec61de573a3767b2a6e819c79ea404fd7cb90a35f1fcb2e230714beb9acc"

  depends_on "cmake" => :build
  depends_on "sdl2"
  depends_on "sdl2_mixer"
  depends_on "minizip"
  depends_on "lzlib"

  def install
    system "make", "mrboom", "LIBSDL2=1"
    bin.install "mrboom.out" => "mrboom"
    man6.install "mrboom.6"
  end

  test do
    system "#{bin}/mrboom", "--version"
  end
end
