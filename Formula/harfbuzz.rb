class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/3.0.0.tar.gz"
  sha256 "55f7e36671b8c5569b6438f80efed2fd663298f785ad2819e115b35b5587ef69"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "18cfea7572cee71e1fa17842f795c7ddffd880743d54c6c0916cd9efed0ae18f"
    sha256 cellar: :any, big_sur:       "578a6aa32fa88436cafddd4bce9cf3c4779f748e3c8f664b486b712550f4ece2"
    sha256 cellar: :any, catalina:      "f92aed1f3128aeeae4854db794aba62d0a0e6dda063c31055f08952b68c92c31"
    sha256 cellar: :any, mojave:        "182656856f737a6d2836f5754f986757b8be9f90a6befb637c6da1265515d450"
    sha256               x86_64_linux:  "ecbc8deb5cdaaa1eed23b6ad9b1ed5494f2c2bb4830fd509ef69afa6ecad96f4"
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
