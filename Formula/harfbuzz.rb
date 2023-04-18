class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/7.1.0.tar.gz"
  sha256 "6c7a358c6e134bd6da4fe39f59ec273ff0ee461697945027b7538287b8c73b1e"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "49464bacf4e6af3dfcbb6c7ad6b3837bff639ad7938909fd5ca412593a9203ff"
    sha256 cellar: :any, arm64_monterey: "a93182e4d1b76b7a5abe3be51d41c65531c603cbdfc069632b1e52f7c6efbd37"
    sha256 cellar: :any, arm64_big_sur:  "7042d7647cfad6bbd8f82768bfc6441d9f6f1b9403492ab3195645902c569dc0"
    sha256 cellar: :any, ventura:        "706c7425225c602226f177c3e08776dcb75cffe271bb8721a406d90a92c2610a"
    sha256 cellar: :any, monterey:       "54a3d3b15ea59065ee0d890ecf1734b2d0dd3d1c1e741b0968ae7fe10e2f1133"
    sha256 cellar: :any, big_sur:        "56eef99328f9979190d1dedb442ec2c363aa5106fa394b204ff5194e288e1afa"
    sha256               x86_64_linux:   "9c8b1d11ca5923600226c21ceba5b755676f910971fd465a79478cc887f55866"
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
