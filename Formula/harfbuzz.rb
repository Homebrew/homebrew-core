class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/4.2.0.tar.gz"
  sha256 "7152d1bdcbd2bf6ba777cfe9161d40564fe0a7583e04e55e0a057d5f4414d3c9"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "159e5209621df3eb03034cb2b432b6d01fe33e7c2bf2210f285425384b00c661"
    sha256 cellar: :any, arm64_big_sur:  "de2c0f39b84f3b333415ec58fad4d40263bde6ef5f10188a0330070a216cd299"
    sha256 cellar: :any, monterey:       "7a37668b43654fd74491e11b43dfc6515aafe0c60842a2bfb8719310dc52534c"
    sha256 cellar: :any, big_sur:        "dbea36f30656f1ad7eedc9c834a66663978f162032f7f941bddb4efafa4bb79f"
    sha256 cellar: :any, catalina:       "eb2d0bf506a6bd6010f271a580663a700b0dfb8d3019b3062c50b854372a5fda"
    sha256               x86_64_linux:   "7a59f1bea6c00148b0e7eae823fb73dddedf442829e512e3770c9bd0dc97abd5"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cairo"
  depends_on "freetype"
  depends_on "glib"
  depends_on "gobject-introspection"
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

    mkdir "build" do
      system "meson", *std_meson_args, *args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    resource("homebrew-test-ttf").stage do
      shape = `echo 'സ്റ്റ്' | #{bin}/hb-shape 270b89df543a7e48e206a2d830c0e10e5265c630.ttf`.chomp
      assert_equal "[glyph201=0+1183|U0D4D=0+0]", shape
    end
  end
end
