class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/refs/tags/8.2.1.tar.gz"
  sha256 "f4f4e4173578fd91ca9ef107ca74640a2b7b9420fd11cebe764a86438561134a"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "2e7c2d6df8a427a7ebf2ac6b0ec0025578125281c0cd512d0a21f1c8252f39bb"
    sha256 cellar: :any, arm64_ventura:  "d89f4635c75c9602747dc361fad56379844c5928a8780596fb8bef398e237ef5"
    sha256 cellar: :any, arm64_monterey: "9eceea30bac981bbe6a784a82a8ed46bdf11d0236b233a7e47ff60f37fe6fcf2"
    sha256 cellar: :any, arm64_big_sur:  "39ef9d2f3e905f6cc9bc29bd3907cf0bd75cf44e440c994c732fa4116eee98b8"
    sha256 cellar: :any, sonoma:         "0ef1c982118f57c86f8ca4351851a6b7184c3c9a624b09952307046309592481"
    sha256 cellar: :any, ventura:        "4ce924437ec673e26aa721675be95ee0a09d68db1ec6f2a599a6154382035897"
    sha256 cellar: :any, monterey:       "ad8f4812dd67bebd4039833d18dfb488f2038abd9f9b3f063f6589309ceaf24a"
    sha256 cellar: :any, big_sur:        "add5998e137dd60041de82d1f99910d772bd090f0c4f4cf54ef23ced7a5e1108"
    sha256               x86_64_linux:   "88b7cbc1cadc2194ff277e1506f995df57d23302ce610b1e2bf2a7a73970f3ea"
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
