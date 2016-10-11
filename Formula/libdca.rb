class Libdca < Formula
  desc "Library for decoding DTS Coherent Acoustics streams"
  homepage "https://www.videolan.org/developers/libdca.html"
  url "https://download.videolan.org/pub/videolan/libdca/0.0.5/libdca-0.0.5.tar.bz2"
  sha256 "dba022e022109a5bacbe122d50917769ff27b64a7bba104bd38ced8de8510642"

  bottle do
    cellar :any
    rebuild 1
    sha256 "5402d2163d46f12bca79ec04ee627cb26f15a5e78299447efbf8a908e714d081" => :sierra
    sha256 "e148c79b756b8684a8a906e493bb4ce3007db3682c0ac8a1b194c76ebb1097a7" => :el_capitan
    sha256 "893590746bb58d06c659af40adce735abcd661691a75ba8b000024aab359e1ca" => :yosemite
    sha256 "9e3a014b2e3f3d5fb35959a1e4144b39c4fc551288393aad856028a1ccbd0fb3" => :mavericks
  end

  def install
    # Fixes "duplicate symbol ___sputc" error when building with clang
    # https://github.com/Homebrew/homebrew/issues/31456
    ENV.append_to_cflags "-std=gnu89"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
