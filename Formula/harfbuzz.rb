class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/3.4.0.tar.gz"
  sha256 "810bcd3d22fae3c2c18c3688455abc1cd0d7fb2fae25404890b0d77e6443bd0a"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "15cdfcae02c662d496ec44853c903bee6e88e3ae6c5824551728d1777b7f3202"
    sha256 cellar: :any, arm64_big_sur:  "4a62926c8c00f94f894330aee3089ee76eace29cee52933b3118ec07c7975b54"
    sha256 cellar: :any, monterey:       "a1dc8c1d20dede22660ff6b7d9a8414da5b83d2a40a3ca4d4e5870c2d1ba3355"
    sha256 cellar: :any, big_sur:        "2f601d4fad7b0c7055b42db634a3b456c8010514cf66047067df64e12fc4b431"
    sha256 cellar: :any, catalina:       "bdac7835aed7dda53981f913588c440b26014ec8d89f76e4f0bfca2541c5db0a"
    sha256               x86_64_linux:   "5de8141091a2738bafaa6c193f123090e0a27ba167eefc960ac526c63daad982"
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
