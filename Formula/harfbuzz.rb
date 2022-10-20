class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/5.3.0.tar.gz"
  sha256 "94712b8cdae68f0b585ec8e3cd8c5160fdc241218119572236497a62dae770de"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "68446a938d415f432f96b8d249b1333e3ea8bdf6f048c76fd26c95a2130f8dcb"
    sha256 cellar: :any, arm64_big_sur:  "ab7f01683be746ba47dc3509c319f017669278eec3a835018438dcd67eba3b71"
    sha256 cellar: :any, monterey:       "8e62abc75bf7eda49862b83fee7c23998b3d895a0d54bef87ba0f9224cd437cf"
    sha256 cellar: :any, big_sur:        "496684204d85d363eec08e029d876d169b2955a2d5c36cd80372e36a49bcdfee"
    sha256 cellar: :any, catalina:       "9cac3ab61691afba8f311b3812d16f3ab8f039b1b6f056e7f3ab30e99dc1ff80"
    sha256               x86_64_linux:   "b14147a25757f16f6230025c05115379e9db5c56ed15ffb52e6f33980cefcb66"
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
