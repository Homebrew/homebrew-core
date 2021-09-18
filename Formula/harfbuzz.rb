class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/3.0.0.tar.gz"
  sha256 "55f7e36671b8c5569b6438f80efed2fd663298f785ad2819e115b35b5587ef69"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2c6e65bfb8670ffa22d2ea75b0f96d9d3855c9865cb42a03f7024dac6c97e428"
    sha256 cellar: :any, big_sur:       "991c547aad91d318700252b2b63dc33a8a203779c9e4e68154d772e24a2fbea7"
    sha256 cellar: :any, catalina:      "476b15a33729452d786e02cead7b3a7a28c0b17df2d8cf2be305e9efde7f4505"
    sha256 cellar: :any, mojave:        "e6b23154bace4983feab6c9704b3a98c0d27c30dc19f2377aa0033891ff6aa20"
    sha256               x86_64_linux:  "bd0b1386501b5a2ec74ac7e6b839ed8a3912f3edcad9d603b699a71e610fa451"
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
