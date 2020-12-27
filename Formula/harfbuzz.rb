class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/2.7.4.tar.gz"
  sha256 "daff8a4003ac420a8550760ed303ce33b310c8ea17b7f15b307d1969cabcebcb"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git"

  bottle do
    cellar :any
    sha256 "c7160e8f5b4682a4183d5c5961330c0cb1950f27a7394eda9e85e956c7805e7f" => :big_sur
    sha256 "85593cfaefdd72a20041d172ddcc051f74bc15ef1b24193d80519a53674ef158" => :arm64_big_sur
    sha256 "52dcdb0161332212f0b406a6555f679b09d61b4b2a0867a49f50553b468e9660" => :catalina
    sha256 "268dae035e50f1d000dc33c81d70310987d523f4f0354409623c1eb00bda1541" => :mojave
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
