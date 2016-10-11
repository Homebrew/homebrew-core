class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://wiki.freedesktop.org/www/Software/HarfBuzz/"
  url "https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-1.3.2.tar.bz2"
  sha256 "8543a6372f08c5987c632dfaa86210c7edb3f43fbacd96095c609bc3539ce027"

  bottle do
    sha256 "a3850c7b5e16813a6710b9acd12b3fe788427835d2de55ef7cdb0532dcd565ab" => :sierra
    sha256 "2871ee7529735d9f221ada0bb93c4ba9484ce5cce1e6e7ec1f08aae24d47b508" => :el_capitan
    sha256 "be8a74fc07921c4b3f727d65849d0a87cb7b0b3ff84fda846ce53827d8e191de" => :yosemite
  end

  head do
    url "https://github.com/behdad/harfbuzz.git"

    depends_on "ragel" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal
  option "with-cairo", "Build command-line utilities that depend on Cairo"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "freetype"
  depends_on "gobject-introspection"
  depends_on "icu4c" => :recommended
  depends_on "cairo" => :optional
  depends_on "graphite2" => :optional

  resource "ttf" do
    url "https://github.com/behdad/harfbuzz/raw/fc0daafab0336b847ac14682e581a8838f36a0bf/test/shaping/fonts/sha1sum/270b89df543a7e48e206a2d830c0e10e5265c630.ttf"
    sha256 "9535d35dab9e002963eef56757c46881f6b3d3b27db24eefcc80929781856c77"
  end

  def install
    ENV.universal_binary if build.universal?

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-introspection=yes
      --with-freetype=yes
      --with-glib=yes
      --with-gobject=yes
      --with-coretext=yes
      --enable-static
    ]

    if build.with? "icu4c"
      args << "--with-icu=yes"
    else
      args << "--with-icu=no"
    end

    if build.with? "graphite2"
      args << "--with-graphite2=yes"
    else
      args << "--with-graphite2=no"
    end

    if build.with? "cairo"
      args << "--with-cairo=yes"
    else
      args << "--with-cairo=no"
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
