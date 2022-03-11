class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/4.0.1.tar.gz"
  sha256 "449edee95208344d75f8e886da6ae390a3e1002e5b3ca4eb7ed42e69958491e2"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "60def725782dc488c1547615c70e4cf0496009093c5ee60fd30d606dc7425b6c"
    sha256 cellar: :any, arm64_big_sur:  "b0b2c2b99c974baeb1d658c851c1718363f776b7c2d49cb01fd64cb5a2ba393b"
    sha256 cellar: :any, monterey:       "db3301490ab9cd124fe717a35674df7e9b704daf9855b5e1d93783f4cf02d3cb"
    sha256 cellar: :any, big_sur:        "14141e091cdf2eaec42961710a2a14e8e4a04fc80616ca59d7f0a3e9659dbb52"
    sha256 cellar: :any, catalina:       "3cb83d3731b65b54ffa9425261d7d50a0ba138bf6e2239cca49d34bffd3fc4ae"
    sha256               x86_64_linux:   "b9c7f9b05eedaa9cec128e02cfd2da319eb0ace82a766a860c06c999ea7f7ab4"
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
