class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/5.1.0.tar.gz"
  sha256 "5352ff2eec538ea9a63a485cf01ad8332a3f63aa79921c5a2e301cef185caea1"
  license "MIT"
  revision 1
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "711052dcdc95465124bb0165d602c406464c5c9cc523ac8504b5e6c64b7386b5"
    sha256 cellar: :any, arm64_big_sur:  "e028adb6c912631dca4beddada6e63f66f47a169cfde3193d2e10bfd1df6a9dc"
    sha256 cellar: :any, monterey:       "8a0cb74c52fbfcfe6a86d20fdf5bc7b2e1565a0611d8a0612bbf004335e21ea4"
    sha256 cellar: :any, big_sur:        "6b5eb4af8354be4651cfca33740f4375d5444af57efcc9a3648f232901100f05"
    sha256 cellar: :any, catalina:       "3ebc2d5fa6682d2dc5662d4f24a2543f9cdedfdc5139a4be294d11d97849e036"
    sha256               x86_64_linux:   "1f957ebb397db7d0a3d4b6ecb8ad72221b085e0a7dd9149a5cb48a322619c783"
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
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    resource("homebrew-test-ttf").stage do
      shape = `echo 'സ്റ്റ്' | #{bin}/hb-shape 270b89df543a7e48e206a2d830c0e10e5265c630.ttf`.chomp
      assert_equal "[glyph201=0+1183|U0D4D=0+0]", shape
    end
    system Formula["python@3.10"].opt_bin/"python3", "-c", "from gi.repository import HarfBuzz"
  end
end
