class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/7.0.1.tar.gz"
  sha256 "9f6601010fc471b8a41f56d529b6000bd3a6df3dca10565794669fa66292457c"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "d66276adf78f850d0e298feeb456808026e7f08caf68121d22ba0c745f3dca93"
    sha256 cellar: :any, arm64_monterey: "84bc6793bbe8d7cad1a3159f6ace6a323351fa13229497ff13fb2713c62d0881"
    sha256 cellar: :any, arm64_big_sur:  "537e88dde210dc5acbac464ea77022f682888dc20eba5b56eff0460f0fe9d43e"
    sha256 cellar: :any, ventura:        "44fbf885cb02f2aa54f3a45d0d1035cc50394d93f2853596a62a2315dc560422"
    sha256 cellar: :any, monterey:       "14cc957df44fa13294363ec8bd7f3d345d8436477ddaa583c214bd779180181e"
    sha256 cellar: :any, big_sur:        "80fb3bcccc78d7ac1005d5abd0f5f8ec94f191442fe74c753ffd57e5f03cee7d"
    sha256               x86_64_linux:   "f98fd6903479d9af00a9871a061926d338075104703236f4bcc43d0e85e09899"
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
