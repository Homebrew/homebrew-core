class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://wiki.freedesktop.org/www/Software/HarfBuzz/"
  url "https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-1.5.1.tar.bz2"
  sha256 "56838dfdad2729b8866763c82d623354d138a4d99d9ffb710c7d377b5cfc7c51"

  bottle do
    sha256 "bb64532ef28955bdd1793423ed4981a6d6203d8fee42ab223080f4f716e8ffb7" => :sierra
    sha256 "f7849db63b85f841aac8a32f6567ec31c907ff37020b5df9d0aef77b29c4fdb6" => :el_capitan
    sha256 "2f53271888cd693929f5d4751f105ff734d2fe71b7e4cc0301b071d3e5d1b46d" => :yosemite
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
