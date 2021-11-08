class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/3.1.1.tar.gz"
  sha256 "5283c7f5f1f06ddb5e2e88319f6946ea37d2eb3a574e0f73f6000de8f9aa34e6"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git"

  bottle do
    sha256 cellar: :any, arm64_monterey: "2c08a88dc59deff8713f3ded94cd5519b66b929416cb6dafc2bd30674c8334cc"
    sha256 cellar: :any, arm64_big_sur:  "bcb35541395ff2b0d6a92ec200c83c04fbc817a4a399c5f12ad973043fe266fd"
    sha256 cellar: :any, monterey:       "b0d6ecafc448ea343ac6019502eb119da609fe39770d9396bd6692e6b4afadb5"
    sha256 cellar: :any, big_sur:        "dc63c7ee20809048cd0242a668f6347953d06a83099994f467405a80e1d73e5c"
    sha256 cellar: :any, catalina:       "ea08266c70c4575b3fb5c88d556232db7c8969ee1f5d67df28d4f38ed1ff0fb8"
    sha256               x86_64_linux:   "90407bb176d60bfa1222dced59c5cb0966f4396db2fd0e53c864f170d4e6e133"
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
