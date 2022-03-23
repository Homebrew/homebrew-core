class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/4.1.0.tar.gz"
  sha256 "0dad9332aa017d216981382cc07a9cf115740990c83b81ce3ea71ad88026d7f1"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "3d3be1a30b51c63ca0bb4ab73dee347f178d450106f84473a8424db6cae854a1"
    sha256 cellar: :any, arm64_big_sur:  "d9fd931a8c1f6b656b3c953933e2934c70ca154d859d15cb11d47f58deb7fad5"
    sha256 cellar: :any, monterey:       "ca96dff2cf9cdb3b3b6fd482db91f46d6ca283f40b8345d5d86430176816a295"
    sha256 cellar: :any, big_sur:        "c7b6726e20de08da54d1210cc2a67189b1d3a6e4f01d67a605311c485042b5bb"
    sha256 cellar: :any, catalina:       "1409bebdb8af4147e299a138555821dcba5970dd4042bc124c281d4a96f96cb0"
    sha256               x86_64_linux:   "a4a48ab9a36aecdbfc57061d32f550f679efa678b810de6e67dff44301fb21c9"
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
