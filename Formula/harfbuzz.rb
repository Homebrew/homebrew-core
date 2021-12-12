class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/3.2.0.tar.gz"
  sha256 "41b38daa13ebdba39fae3b5fb2abbf5f9ccd9121bfa7f47b18d51aa733f80aad"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git"

  bottle do
    sha256 cellar: :any, arm64_monterey: "9c58448bf305cf996c5402c6652b4630b9447ab19e153ef0434a2c1171633ff9"
    sha256 cellar: :any, arm64_big_sur:  "94ebc04f6ec24595254121f84e7beaae454991f6291baa69c383dd0084baf7db"
    sha256 cellar: :any, monterey:       "78243d1d277e3ed9f2bee0febddeef4f5fb702aa57a9df67737d6829aae33906"
    sha256 cellar: :any, big_sur:        "3aa3415cd02a917911c84331c8038164dcb3143388cdd9ef4588c6017a49d72d"
    sha256 cellar: :any, catalina:       "80e277c20fa04d2413f2273d52ddd920d287dc3f37ea4f698c396eded40b2588"
    sha256               x86_64_linux:   "d3a8005785d97ce3af9edd6a938eb84da99ddb01805b2f2d590a336449390fe5"
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
