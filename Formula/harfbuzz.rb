class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://wiki.freedesktop.org/www/Software/HarfBuzz/"
  url "https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-2.2.0.tar.bz2"
  sha256 "b7ccfcbd56b970a709e8b9ea9fb46c922c606c2feef8f086fb6a8492e530f810"

  bottle do
    sha256 "1abb827d792e1eaceb8ac4dee2c229c397700bc1ec1b09cd892927ef4c79f81c" => :mojave
    sha256 "026b71cba62332d52269304541ae1e2f1fc5c15711461257d2dd9f15a76286b4" => :high_sierra
    sha256 "12b56f39902912c8346b92892c824f0bfff79285072b32f4f33412260206b4ec" => :sierra
  end

  head do
    url "https://github.com/behdad/harfbuzz.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "ragel" => :build
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "freetype"
  depends_on "glib"
  depends_on "graphite2"
  depends_on "icu4c"

  resource "ttf" do
    url "https://github.com/behdad/harfbuzz/raw/fc0daafab0336b847ac14682e581a8838f36a0bf/test/shaping/fonts/sha1sum/270b89df543a7e48e206a2d830c0e10e5265c630.ttf"
    sha256 "9535d35dab9e002963eef56757c46881f6b3d3b27db24eefcc80929781856c77"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-introspection=yes
      --enable-static
      --with-cairo=yes
      --with-coretext=yes
      --with-freetype=yes
      --with-glib=yes
      --with-gobject=yes
      --with-graphite2=yes
      --with-icu=yes
    ]

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    resource("ttf").stage do
      shape = `echo 'സ്റ്റ്' | #{bin}/hb-shape 270b89df543a7e48e206a2d830c0e10e5265c630.ttf`.chomp
      assert_equal "[glyph201=0+1183|U0D4D=0+0]", shape
    end
  end
end
