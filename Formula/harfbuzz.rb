class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/4.0.0.tar.gz"
  sha256 "4880c25022100c31aef4bdea084be2fe58020f9756e94151b8d1cbf0be1ed54c"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "c1dd7a733839724b48c1ffc1b494362513e31afea383009b95726d1d4b6628fb"
    sha256 cellar: :any, arm64_big_sur:  "3d4804d56ff71d27906e808e1580c14148aa0e7a27edd6bd9b90aa1719e5451a"
    sha256 cellar: :any, monterey:       "d81d3df88c8d73a7028397f8f4851af4359ebf7b7f2ba6b2a6be3c02af7108cb"
    sha256 cellar: :any, big_sur:        "17b93fa58e799a43e478b0c2f954a5b67ab053b4272835654e3fad744494f170"
    sha256 cellar: :any, catalina:       "bbd0499c2cd3dcb3606e6121ba698b230819f33fcfeac0a9315582c9af379b86"
    sha256               x86_64_linux:   "70d88de7732785993f765a85e4a200faaa7b992b5bcc20685bbbebfad00f7897"
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
