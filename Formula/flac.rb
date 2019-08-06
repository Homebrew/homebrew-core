class Flac < Formula
  desc "Free lossless audio codec"
  homepage "https://xiph.org/flac/"
  url "https://downloads.xiph.org/releases/flac/flac-1.3.3.tar.xz"
  sha256 "213e82bd716c9de6db2f98bcadbc4c24c7e2efe8c75939a1a84e28539c4e1748"

  bottle do
    cellar :any
    sha256 "e3972de751c58d0b835ef606f5d21c4ef22bbac927b17f75440259fb2da06bd6" => :mojave
    sha256 "b439d1a0321f9488ad0a2edfe3307402cca4e7f5e560a833078fa29561fadacd" => :high_sierra
    sha256 "27aef309b675e9946f6ac4d090a0322d0888789087b2e38cbaaabc527eb3f22b" => :sierra
    sha256 "17fb6eec1e71416a0000e507953babd4fca2a0204f48ae064d02b76b906dc096" => :el_capitan
  end

  head do
    url "https://git.xiph.org/flac.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libogg"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-debug
      --prefix=#{prefix}
      --enable-static
    ]
    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/flac", "--decode", "--force-raw", "--endian=little", "--sign=signed", "--output-name=out.raw", test_fixtures("test.flac")
    system "#{bin}/flac", "--endian=little", "--sign=signed", "--channels=1", "--bps=8", "--sample-rate=8000", "--output-name=out.flac", "out.raw"
  end
end
