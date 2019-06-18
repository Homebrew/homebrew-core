class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://wiki.freedesktop.org/www/Software/HarfBuzz/"
  url "https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-2.5.1.tar.xz"
  sha256 "6d4834579abd5f7ab3861c085b4c55129f78b27fe47961fd96769d3704f6719e"
  revision 1

  bottle do
    cellar :any
    sha256 "11a93b1bdd447c17b0dae47c03f29b9244168e4a6add2a45051e9a805e979534" => :mojave
    sha256 "ba88b18a661d1f6b4fdb35c0fe82f6c6782ea39b26c23197f923001ec1cdb8b3" => :high_sierra
    sha256 "cb521d1047e509c5ca6093d3aae656a9ddb534f1a0aee7ab22ec599edfdad499" => :sierra
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
