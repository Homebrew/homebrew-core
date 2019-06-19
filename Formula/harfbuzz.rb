class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://wiki.freedesktop.org/www/Software/HarfBuzz/"
  url "https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-2.5.1.tar.xz"
  sha256 "6d4834579abd5f7ab3861c085b4c55129f78b27fe47961fd96769d3704f6719e"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "2b9d512265903c00e8afc23fadec665c2c31ac40a098e66a9202b0d29385e053" => :mojave
    sha256 "b4e38cc65ed3c09bede46872aa30f438cf724aec98d600fe681ca5b3e734856e" => :high_sierra
    sha256 "c510e2101e0e89eee99742b37b8d6a237668dd176473376d5b225bbbeaf02687" => :sierra
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

  # Fixes building on clang with -Wextra-semi-stmt.
  # Both patches are in master, should be in the next release.
  # https://github.com/harfbuzz/harfbuzz/pull/1783
  patch do
    url "https://github.com/harfbuzz/harfbuzz/commit/10bac21bb5b25cf20c2198934e99e444625dfd97.patch?full_index=1"
    sha256 "7392a5cf71d922105a978e7074f918d20ade6c4e83f864d73b6f12d50ffeefd6"
  end

  patch do
    url "https://github.com/harfbuzz/harfbuzz/commit/e710888188ff3285a162c25c89d886d9535d9f02.patch?full_index=1"
    sha256 "eaf09af93510f2d13d640d44da3a055b7f08fe5b9d48ef9f4ef2a3adfdbc8b07"
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
