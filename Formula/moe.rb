class Moe < Formula
  desc "Console text editor for ISO-8859 and ASCII"
  homepage "https://www.gnu.org/software/moe/moe.html"
  url "https://ftp.gnu.org/gnu/moe/moe-1.12.tar.lz"
  mirror "https://ftpmirror.gnu.org/moe/moe-1.12.tar.lz"
  sha256 "8a885f2be426f8e04ad39c96012bd860954085a23744f2451663168826d7a1e8"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "0ef61e0d2ff4d8c1a6c6c113d678ab3dd2395330e977a82d98b0c5d7dcb0d5df"
    sha256 arm64_big_sur:  "4cd1ae57f10541bfdd1b593b03e23ec95c8505b9333910fea5a44609944db357"
    sha256 monterey:       "a88056ecb34970e4d33907be5c005b16c2dec0ff2f66a4a2600002c5ae65ad2d"
    sha256 big_sur:        "8a52882de612e38223232d3ec439d16e9aeeb3da3df3aed2f17c9e25bc4d4578"
    sha256 catalina:       "214f04ee485f292e4e33ce30a51385b118ba659fb97acef683a7aa0c07da4059"
    sha256 x86_64_linux:   "16febfa1ebd84d151fe0c5f6c1490ab9a27693ec35e6550ef1f65b72518cc381"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/moe", "--version"
  end
end
