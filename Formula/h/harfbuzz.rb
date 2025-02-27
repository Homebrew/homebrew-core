class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/refs/tags/10.3.0.tar.gz"
  sha256 "39cd3df7217f2477cf31f3c9d3a002e4d5ef0ba6822151e82ea6b46e42ea1cb2"
  license "MIT"
  revision 1
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "dda9be15e9537e696e55cda8bd9d7b2250bd200441e7d4ca3b13dc84fd770944"
    sha256 cellar: :any, arm64_sonoma:  "a0b89a4c90947f3b4a6451b329fc62a49d179f77590386b753efce1b18afba11"
    sha256 cellar: :any, arm64_ventura: "4e25e72d3edff2420801734fc7639558fa4fa4272a7fd382fc4f9152cc181370"
    sha256 cellar: :any, sonoma:        "53328e7399caaf326c22cd0de7e47902c16cd60bcec049e74c83eba31a8babf9"
    sha256 cellar: :any, ventura:       "612b94277ed591d40f8f59b915260043951205582cbb0d480a0155e6fc3a152b"
    sha256               x86_64_linux:  "fa037c63e24e3b17e5687bc9102bafc803580284c5c898e973c5a07dedb858bf"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "pygobject3" => :test
  depends_on "cairo"
  depends_on "freetype"
  depends_on "glib"
  depends_on "graphite2"
  depends_on "icu4c@77"

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

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    resource("homebrew-test-ttf").stage do
      shape = pipe_output("#{bin}/hb-shape 270b89df543a7e48e206a2d830c0e10e5265c630.ttf", "സ്റ്റ്").chomp
      assert_equal "[glyph201=0+1183|U0D4D=0+0]", shape
    end
    system "python3.13", "-c", "from gi.repository import HarfBuzz"
  end
end
