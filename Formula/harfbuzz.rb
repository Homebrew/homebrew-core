class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/3.1.1.tar.gz"
  sha256 "5283c7f5f1f06ddb5e2e88319f6946ea37d2eb3a574e0f73f6000de8f9aa34e6"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git"

  bottle do
    sha256 cellar: :any, arm64_monterey: "9c0561fefc40dfc2fc67834cdebfeae39ba36d677a70ec361514fa84114ffc5d"
    sha256 cellar: :any, arm64_big_sur:  "a82cee1c83fc4d82b3c4444915e874eb3b5f1c49e506e100ebc06da149a82264"
    sha256 cellar: :any, monterey:       "bd1dc2ccd39a5ea6e3ac317e45215d057fc45c5e525137b70237f5ab7b89faff"
    sha256 cellar: :any, big_sur:        "7a08203ef5ced555a0d2f3b9531aaf8dd82270c2b8a622a3555d99a103171300"
    sha256 cellar: :any, catalina:       "119cee4a1a7e81d42d6a3d6ec996e4158ca17ac5fb7e39b6cd10b9443e0f1a15"
    sha256               x86_64_linux:   "6b4e8f51a984c6a631ccb9e4747280ae7319918baccd9ba14cae9393fd340618"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cairo"
  depends_on "freetype"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "graphite2"
  depends_on "icu4c"

  resource "ttf" do
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
    resource("ttf").stage do
      shape = `echo 'സ്റ്റ്' | #{bin}/hb-shape 270b89df543a7e48e206a2d830c0e10e5265c630.ttf`.chomp
      assert_equal "[glyph201=0+1183|U0D4D=0+0]", shape
    end
  end
end
