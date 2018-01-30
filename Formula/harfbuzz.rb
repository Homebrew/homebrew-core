class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://wiki.freedesktop.org/www/Software/HarfBuzz/"
  url "https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-1.7.5.tar.bz2"
  sha256 "84574e1b1f65ca694cb8fb6905309665c0368af18a312357f8ff886ee2f29563"

  bottle do
    sha256 "1ce0a004729487dfca29c01714914ca359c0d42e3a5f197c7b125fca6c6daefa" => :high_sierra
    sha256 "b4f8783f68cbd172ca4b24f49e5b9c041a20bb0b63c2f80e7cfcea872317df4c" => :sierra
    sha256 "3a5c54949242f8ba5fe2dbab60cb82db0c28b34d74267d68840277f2e7df15dc" => :el_capitan
  end

  head do
    url "https://github.com/behdad/harfbuzz.git"

    depends_on "ragel" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-cairo", "Build command-line utilities that depend on Cairo"

  depends_on "pkg-config" => :build
  depends_on "freetype" => :recommended
  depends_on "glib" => :recommended
  depends_on "gobject-introspection" => :recommended
  depends_on "graphite2" => :recommended
  depends_on "icu4c" => :recommended
  depends_on "cairo" => :optional

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
    ]

    if build.with? "cairo"
      args << "--with-cairo=yes"
    else
      args << "--with-cairo=no"
    end

    if build.with? "freetype"
      args << "--with-freetype=yes"
    else
      args << "--with-freetype=no"
    end

    if build.with? "glib"
      args << "--with-glib=yes"
    else
      args << "--with-glib=no"
    end

    if build.with? "gobject-introspection"
      args << "--with-gobject=yes" << "--enable-introspection=yes"
    else
      args << "--with-gobject=no" << "--enable-introspection=no"
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
