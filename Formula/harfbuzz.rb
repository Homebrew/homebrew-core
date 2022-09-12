class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/5.1.0.tar.gz"
  sha256 "5352ff2eec538ea9a63a485cf01ad8332a3f63aa79921c5a2e301cef185caea1"
  license "MIT"
  revision 1
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "924ac84d17623828541d4585f653bee6d293a128aad070af9ef4f85a3ca4a057"
    sha256 cellar: :any, arm64_big_sur:  "686884d720afe3db1e2798dba1b1f2954bc5cffe77e393c51b142c7f2a27fb08"
    sha256 cellar: :any, monterey:       "0ae9a507668a64649d083818c02b66e5f97d7c6ca0fb3f67f3fee0d8b889b25b"
    sha256 cellar: :any, big_sur:        "59c58d735e7d21632fc9648623748850c6ab641bfd6bf1b3ab8cad9b163e65c5"
    sha256 cellar: :any, catalina:       "bac3693891bf564c1ea767a7681fbd239ed2ba656dcf6029a0bc3184f2dc2ec2"
    sha256               x86_64_linux:   "249b5e97c383242cb0043c6040f4ce0b190be13c3afd6f56cfb78d77c5966ca2"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.10" => [:build, :test]
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
    ]

    system "meson", "setup", "build", *std_meson_args, *args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    resource("homebrew-test-ttf").stage do
      shape = `echo 'സ്റ്റ്' | #{bin}/hb-shape 270b89df543a7e48e206a2d830c0e10e5265c630.ttf`.chomp
      assert_equal "[glyph201=0+1183|U0D4D=0+0]", shape
    end
    system "python3.10", "-c", "from gi.repository import HarfBuzz"
  end
end
