class Advancemame < Formula
  desc "MAME with advanced video support"
  homepage "https://www.advancemame.it/"
  url "https://github.com/amadvance/advancemame/releases/download/v3.9/advancemame-3.9.tar.gz"
  sha256 "3e4628e1577e70a1dbe104f17b1b746745b8eda80837f53fbf7b091c88be8c2b"
  license "GPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "88ad9298b1e887db21c6e9126578c517b767b420393453f95ab3c8cb61af014d"
    sha256 arm64_big_sur:  "fe56e046756c3f764cbe72137877c3bde3fd157175fc2347ae85874f9c2abe2b"
    sha256 monterey:       "c6ccc21e6f7a58fe68cbb00733411032c56b8caba8ed2aa1309829661d626b07"
    sha256 big_sur:        "b04cdb0a02ef28b8626eb92c9da9ae784e7f7ba7f6ab8675cd40e5d976e46228"
    sha256 catalina:       "7530ca2e37ac45b53164ae54ab6669f1796ea0af88541a85a93a74c155fb0029"
    sha256 mojave:         "95f2cdff91ff98c3c9f65a0751d7948cefb3829d96e1977b5b8869163eba0790"
    sha256 high_sierra:    "9c5e0a9f81f43ec02eb951b82b4930639dafcdbacbeadf7bcc5e74f2e2ec7c45"
    sha256 sierra:         "6ba2c02db07a9ef7ddf561dbc2cde3904abe0b1b0ab9c9469020fdeced72e011"
    sha256 x86_64_linux:   "d0bab1d3cfd93b32811ab90959ee6223f97528c6b4ac1e51c353f3dfad1579cc"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "sdl"

  uses_from_macos "expat"
  uses_from_macos "ncurses"

  conflicts_with "advancemenu", because: "both install `advmenu` binaries"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install", "LDFLAGS=#{ENV.ldflags}", "mandir=#{man}", "docdir=#{doc}"
  end

  test do
    system "#{bin}/advmame", "--version"
  end
end
