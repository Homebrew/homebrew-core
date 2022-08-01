class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/5.0.1.tar.gz"
  sha256 "a3ebdef007189f7df4dd50b73a955006d012b3aef81fa9650dbcf73a614e83c6"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "a0dca1f19cf2006cd24181af5d97959d41aca06c4bdf165c754cc5d27c64eb53"
    sha256 cellar: :any, arm64_big_sur:  "2d381283d0087da41b05e5b048a1884474115f89cb5facebd3040de0e9668551"
    sha256 cellar: :any, monterey:       "a4563d79c97ce8a84f4ac45a2c5ca8b0e2e7b08619ab2e73fb8bc231bb27af38"
    sha256 cellar: :any, big_sur:        "158f5239dcaafcff4620750a932ac1f92179d3acbb6403a1d6d81953d27b867e"
    sha256 cellar: :any, catalina:       "b362d361288f291b170a91568c6bd53b631dec2b228883cf7cfcc6b772017b09"
    sha256               x86_64_linux:   "723cc7f0bfd836e5d484c30406457c27f0a498d11a71c6ccb1457dd0434c73f6"
  end

  depends_on "glib-utils" => :build
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
