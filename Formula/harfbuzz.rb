class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/7.1.0.tar.gz"
  sha256 "6c7a358c6e134bd6da4fe39f59ec273ff0ee461697945027b7538287b8c73b1e"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "9be79b5d81a65ebceddb4edb19681c686c79673cab9f254782388f00ebc156a3"
    sha256 cellar: :any, arm64_monterey: "18ee2c2e6f4f2e71c687d9876bac7e76853b255643b405500e12ec5c2e3d17f5"
    sha256 cellar: :any, arm64_big_sur:  "667dc03a21d739c1062285987991fffe1c9a374114bf54a91f331c97a8dcac9f"
    sha256 cellar: :any, ventura:        "d7350f3ef9ad1b8df09da44e51354aa18f1c4f4eb91e0cf61d49a860b0627ad7"
    sha256 cellar: :any, monterey:       "6dd99cf8b279c86e86c656ef020172f3347090f41d71143cd04313056fff74d8"
    sha256 cellar: :any, big_sur:        "4fe4ddb06c26ac051758f26500ffc00dccf1c4e1c91220e2c63f8458c681bfcf"
    sha256               x86_64_linux:   "a64f01f6fd0b4627582dfdc121fadfd8ff521122fbe0e32ef565cf03554f4912"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => [:build, :test]
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
      -Dtests=disabled
    ]

    system "meson", "setup", "build", *std_meson_args, *args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    resource("homebrew-test-ttf").stage do
      shape = pipe_output("#{bin}/hb-shape 270b89df543a7e48e206a2d830c0e10e5265c630.ttf", "സ്റ്റ്").chomp
      assert_equal "[glyph201=0+1183|U0D4D=0+0]", shape
    end
    system "python3.11", "-c", "from gi.repository import HarfBuzz"
  end
end
