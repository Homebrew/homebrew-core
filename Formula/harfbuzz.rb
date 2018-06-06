class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://wiki.freedesktop.org/www/Software/HarfBuzz/"
  url "https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-1.7.7.tar.bz2"
  sha256 "6e1a56db1b8335cb8f7cb625536d6443fc34801ae419d66e445efea885a62128"

  bottle do
    sha256 "d6fee7d52a7f995063c333d4a8003bacdd6b9456712e92042a2e22090edd2164" => :high_sierra
    sha256 "a2563a06d73f61fa766b6fabcd2d82199b5fe35d9be09bfbf091aed926cbfb42" => :sierra
    sha256 "5da39c66082e7d473fc5a78e40f8151fb11522b02597a2a9dae6fb5c05072b09" => :el_capitan
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
