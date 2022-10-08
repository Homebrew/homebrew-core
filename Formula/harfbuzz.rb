class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/5.3.0.tar.gz"
  sha256 "94712b8cdae68f0b585ec8e3cd8c5160fdc241218119572236497a62dae770de"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "35eb41afc88b76e92e05001674820a1ce17e1d63c8c6308494dfff0855685b7f"
    sha256 cellar: :any, arm64_big_sur:  "5e61ea6a789232aeab0bae5ad7c303a84bae365982741aa2321fd047325a073f"
    sha256 cellar: :any, monterey:       "39cc6b56382350e7f97e3e9c69ac2886766942ec05d29468be6a407195b880da"
    sha256 cellar: :any, big_sur:        "2a141e5f007868d2e11c14c8b9284d31499599a57da136c17c0dd3976e6bb98d"
    sha256 cellar: :any, catalina:       "eb4a66a06100a0b8a47e283b30db299ad7ca6f0d654de9fe32e28fbf43092521"
    sha256               x86_64_linux:   "aaab5b8032e6447c98b02a04505716c8893a9b53e6241cc7d955626303bb92c1"
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
