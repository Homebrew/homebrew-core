class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/2.8.1.tar.gz"
  sha256 "b3f17394c5bccee456172b2b30ddec0bb87e9c5df38b4559a973d14ccd04509d"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "b39a15bf3afca871c705e6abd1762376f48cc33e315f892adeee1bdcd1d6f623"
    sha256 cellar: :any, big_sur:       "c058750b71d64974110c4fdf3dac4cb4ccd37ea02d1ba2b7817c38d57df780a9"
    sha256 cellar: :any, catalina:      "5f8566c2a97c8572f399f0ecc9e6ba906feb1c81add4f0ee655d445fec649a59"
    sha256 cellar: :any, mojave:        "de88d7a4b48c0d2bd8d006705ffcecbb70e222e35e671943af4f4d12b9c4a46b"
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
