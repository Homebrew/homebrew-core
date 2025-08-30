class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/refs/tags/11.4.5.tar.gz"
  sha256 "5bc7a571b476eeda0c1996a04006da7c25f8edbc01cdf394ef729a6ecd1296d6"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "370e265869f5d889a809a558484ffdf21e04317817a649b4dcbbe9ac4bbda5f5"
    sha256 cellar: :any, arm64_sonoma:  "851d0d7fc80acfe1a0b663346e0cc2e63c21e61bcbc4fb3a4021074cea5d2d00"
    sha256 cellar: :any, arm64_ventura: "acd15af064aa90a93829887c48958d911909c9f7b50156cd9579410e0ed9c37f"
    sha256 cellar: :any, sonoma:        "b219262b79e353710f918c15a701f6e6f7cf80a82ca3aaa3353b862690f04d31"
    sha256 cellar: :any, ventura:       "a37bc9f46cffd1450270cb7486b282e7984cc0398e19e2b458ad914e51289562"
    sha256               arm64_linux:   "148d9be45c1f3cfacc42118723b663fe7c83ecefd1db7a9fb777ec88a4eabc09"
    sha256               x86_64_linux:  "c4a77ef17c7e3ac919f15db33735fc2fbf5294c513260eaf8c99d0b2bac1f0a2"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "pygobject3" => :test
  depends_on "cairo"
  depends_on "freetype"
  depends_on "glib"
  depends_on "graphite2"
  depends_on "icu4c@77"

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

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    resource "homebrew-test-ttf" do
      url "https://github.com/harfbuzz/harfbuzz/raw/fc0daafab0336b847ac14682e581a8838f36a0bf/test/shaping/fonts/sha1sum/270b89df543a7e48e206a2d830c0e10e5265c630.ttf"
      sha256 "9535d35dab9e002963eef56757c46881f6b3d3b27db24eefcc80929781856c77"
    end

    resource("homebrew-test-ttf").stage do
      shape = pipe_output("#{bin}/hb-shape 270b89df543a7e48e206a2d830c0e10e5265c630.ttf", "സ്റ്റ്").chomp
      assert_equal "[glyph201=0+1183|U0D4D=0+0]", shape
    end
    system "python3.13", "-c", "from gi.repository import HarfBuzz"
  end
end
