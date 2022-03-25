class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/4.1.0.tar.gz"
  sha256 "0dad9332aa017d216981382cc07a9cf115740990c83b81ce3ea71ad88026d7f1"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "1781358dcd008c5f40d20b8d5ed2587dc7f267fe03c0f81f74fff9d09d32ea06"
    sha256 cellar: :any, arm64_big_sur:  "cccad95d025c96025ec37baecbeae35a0041c0c40a9724166a6d8f447dbfc8b1"
    sha256 cellar: :any, monterey:       "c284e088536c3ebe66b5f8c841d8cd9ec76152ac1297ca638210e6fd15520f08"
    sha256 cellar: :any, big_sur:        "e0cb219e70d78ccf818e4f24e4b1f66b75c7963d73528a3e12595183f995c01d"
    sha256 cellar: :any, catalina:       "00d14d36fafc5dda2a6e2f342b3b8c1e01919e26acb12f19f4672fec724a92cd"
    sha256               x86_64_linux:   "726cf81c2c6066ed95224f17ef30e3bb7c45bd09607c4475c129952114bf27bc"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cairo"
  depends_on "freetype"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "graphite2"
  depends_on "icu4c"

  resource "homebrew-test-ttf" do
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
    resource("homebrew-test-ttf").stage do
      shape = `echo 'സ്റ്റ്' | #{bin}/hb-shape 270b89df543a7e48e206a2d830c0e10e5265c630.ttf`.chomp
      assert_equal "[glyph201=0+1183|U0D4D=0+0]", shape
    end
  end
end
