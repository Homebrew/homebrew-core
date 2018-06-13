class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://wiki.freedesktop.org/www/Software/HarfBuzz/"
  url "https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-1.8.1.tar.bz2"
  sha256 "fbed6392ddb085e45e6090a9f389f72926d0e355f4b0a2ef51d35cf21686df45"

  bottle do
    sha256 "73455fc19521f82f81bd8812f9e53376c54d3de40821aa9d43ea73d21b28d222" => :high_sierra
    sha256 "9284a009b4a7f3d210e0088f78c9e8b7d728ba2f406f89c9f53fae0f5ec9747c" => :sierra
    sha256 "40e7e3d41267f8938a11f942d2196aa1d7a44cf6da6114c1cbd269d9e8e834e9" => :el_capitan
  end

  head do
    url "https://github.com/behdad/harfbuzz.git"

    depends_on "ragel" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gobject-introspection" => :build
  depends_on "freetype" => :recommended
  depends_on "graphite2" => :recommended
  depends_on "icu4c" => :recommended
  depends_on "cairo"
  depends_on "glib"

  resource "ttf" do
    url "https://github.com/behdad/harfbuzz/raw/fc0daafab0336b847ac14682e581a8838f36a0bf/test/shaping/fonts/sha1sum/270b89df543a7e48e206a2d830c0e10e5265c630.ttf"
    sha256 "9535d35dab9e002963eef56757c46881f6b3d3b27db24eefcc80929781856c77"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-coretext=yes
      --enable-static
      --with-cairo=yes
      --with-glib=yes
      --with-gobject=yes
      --enable-introspection=yes
    ]

    if build.with? "freetype"
      args << "--with-freetype=yes"
    else
      args << "--with-freetype=no"
    end

    if build.with? "graphite2"
      args << "--with-graphite2=yes"
    else
      args << "--with-graphite2=no"
    end

    if build.with? "icu4c"
      args << "--with-icu=yes"
    else
      args << "--with-icu=no"
    end

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
