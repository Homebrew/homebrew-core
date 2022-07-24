class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/5.0.1.tar.gz"
  sha256 "a3ebdef007189f7df4dd50b73a955006d012b3aef81fa9650dbcf73a614e83c6"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "43eb9dffca6648a3b4718b7ba7a7a51dde9a9b5342c52ce3c586dfbf23f97c5f"
    sha256 cellar: :any, arm64_big_sur:  "c420a6936767080423fed5c12063be25d9e12c71372d07a3dee6dd3d5a17a970"
    sha256 cellar: :any, monterey:       "073d043d408cc4defd7d3b337d30b8fcdfac18c07e6928002038687102b90c90"
    sha256 cellar: :any, big_sur:        "2ee365068d158bb4e885b4ca73297e7c8def54b6adbc1b6bb34b56258a4b7a00"
    sha256 cellar: :any, catalina:       "60d36dcca15c1102e6b29ec41937ca87d56fd0467ea1ebb59efee1462c9da92d"
    sha256               x86_64_linux:   "130224a18f8f53fc96386bc6cb47b0868ff5434d725e83a352c035d06f195f32"
  end

  depends_on "glib-utils" => :build
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
