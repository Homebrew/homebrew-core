class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/2.7.4.tar.gz"
  sha256 "daff8a4003ac420a8550760ed303ce33b310c8ea17b7f15b307d1969cabcebcb"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git"

  bottle do
    cellar :any
    sha256 "a5c40fc0b4468f95f0da11ffc715101f88ba3d9fb7ceb026e26274de26725790" => :big_sur
    sha256 "534c9b9087454d1fc6a52771af6515fc96d65846a7f77fe21ef56cddd1e9d15e" => :arm64_big_sur
    sha256 "e70ac334d625b9f857d413ab76f090eca607a04c43f4fa363f69c83034b81c2b" => :catalina
    sha256 "a18f49cd4d23a1df7dec21e603b0d477deb59835eee31b61e32ce6dd58341148" => :mojave
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cairo"
  depends_on "freetype"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "graphite2"
  depends_on "icu4c"

  resource "ttf" do
    url "https://github.com/harfbuzz/harfbuzz/raw/fc0daafab0336b847ac14682e581a8838f36a0bf/test/shaping/fonts/sha1sum/270b89df543a7e48e206a2d830c0e10e5265c630.ttf"
    sha256 "9535d35dab9e002963eef56757c46881f6b3d3b27db24eefcc80929781856c77"
  end

  def install
    args = %w[
      --default-library=both
      -Dcairo=enabled
      -Dcoretext=enabled
      -Dfreetype=enabled
      -Dglib=enabled
      -Dgobject=enabled
      -Dgraphite=enabled
      -Dicu=enabled
      -Dintrospection=enabled
    ]

    mkdir "build" do
      system "meson", *std_meson_args, *args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    resource("ttf").stage do
      shape = `echo 'സ്റ്റ്' | #{bin}/hb-shape 270b89df543a7e48e206a2d830c0e10e5265c630.ttf`.chomp
      assert_equal "[glyph201=0+1183|U0D4D=0+0]", shape
    end
  end
end
