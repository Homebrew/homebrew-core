class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/3.3.2.tar.gz"
  sha256 "49df72f1a534ccbd0c99aec198b24185d37541127dccff49300ee65a3c05e637"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "78f9bed30a6a617cc5abb97ff6b0750244f9960d90788be42217d700571a55c8"
    sha256 cellar: :any, arm64_big_sur:  "b02ec46e29991e095f45db2e693dd9290d917a81a75b8debbd232442beaa9fad"
    sha256 cellar: :any, monterey:       "7b63171441c17187dcd63339954c25152803d7ba9c30862b916c03c01e6e4c2f"
    sha256 cellar: :any, big_sur:        "d3328df4485e6481888e2df40da19ddf476fd8704cda853359a6396199096880"
    sha256 cellar: :any, catalina:       "01b808c7ad290ff78885c685f236a3e6a390aeafa52436c07a77662e1446ca91"
    sha256               x86_64_linux:   "b85091cc1ddab3fb691b29aa39c677061407dd677a0b1527d9d23d83056c1489"
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
