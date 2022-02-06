class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/3.3.2.tar.gz"
  sha256 "49df72f1a534ccbd0c99aec198b24185d37541127dccff49300ee65a3c05e637"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "e72b14589c8ae44661791b87b90476135ef98b054e35c4aa0b5b3bc3fd9b9319"
    sha256 cellar: :any, arm64_big_sur:  "7182c053bfe640cebb30125f9c883412da7e6f5df6deb54a296b09d8a9496374"
    sha256 cellar: :any, monterey:       "cb5ce4c0a35c576b77e7d21625d9e5a5eabb6050dda31a2d41ac5a9622958c37"
    sha256 cellar: :any, big_sur:        "5e8dd0f966b54798edf3e257173e1e731791c13e4053e4985a334b364977f560"
    sha256 cellar: :any, catalina:       "cc6836b5a9a2ed7072210d4ff6f5895ad184fce0662bc53ba73eaed6b43ed7da"
    sha256               x86_64_linux:   "4bbbd8dcc252be928dc594a1519a6a634565e59773de97947097a4204e92938e"
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
