class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/7.0.0.tar.gz"
  sha256 "770dace6561ae11de5838e5dc0ec5e95978b2c029aaee00389856a7ca65b43d9"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "469d30da77414cc94994cf99cb6c3d1809db910bc20433edca00523d00bd845f"
    sha256 cellar: :any, arm64_monterey: "3ab807f3fa8c6a64af82fa41fafcc5c4004f1c9ca39770fb62d8d0b1bfe2124c"
    sha256 cellar: :any, arm64_big_sur:  "f49cbdaf697a44b1c0cd68e31dc6386d411e4ba84fac37d42ba14d7a39726335"
    sha256 cellar: :any, ventura:        "ec10d542f19647d096f9467ea02df118bc246ad6b9962abd628f0df2df2b79b1"
    sha256 cellar: :any, monterey:       "0459ed5214d1ec678d8e9c32d14eaeda53ca741ea71b78f49d27ffd1828f79b2"
    sha256 cellar: :any, big_sur:        "3b6d029e79c56ce81ba55b159226744e743625b934f066b59454d38eaa7b1328"
    sha256               x86_64_linux:   "72c99f2108ade75e4da6c8d58bc9e8e31d258eb0f82a472d8ed19e6132b4e41d"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "pygobject3" => :test
  depends_on "cairo"
  depends_on "freetype"
  depends_on "glib"
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
      -Dtests=disabled
    ]

    system "meson", "setup", "build", *std_meson_args, *args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    resource("homebrew-test-ttf").stage do
      shape = pipe_output("#{bin}/hb-shape 270b89df543a7e48e206a2d830c0e10e5265c630.ttf", "സ്റ്റ്").chomp
      assert_equal "[glyph201=0+1183|U0D4D=0+0]", shape
    end
    system "python3.11", "-c", "from gi.repository import HarfBuzz"
  end
end
