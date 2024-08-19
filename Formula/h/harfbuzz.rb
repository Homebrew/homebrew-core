class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/refs/tags/9.0.0.tar.gz"
  sha256 "b7e481b109d19aefdba31e9f5888aa0cdfbe7608fed9a43494c060ce1f8a34d2"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "9b683aa2fa183d1b26a5a2758663bebc1d45042be4c90cd3a5ab9de9c5d77d42"
    sha256 cellar: :any, arm64_ventura:  "c565c041c5acf667970844755cfb9ed546607a0027fcefce6e2f055201212823"
    sha256 cellar: :any, arm64_monterey: "b877274a0347b535bd526fc2b95b9aaabb3758b5bea76344adc71aabfd9e45ba"
    sha256 cellar: :any, sonoma:         "748d0382c160b1501bc1e3020a7963b794d6afed4239f1baa4c01b7bd0f3b760"
    sha256 cellar: :any, ventura:        "90cd2b6049560e6b719f666bf62c2a2a5ef4ee71717c249792d61ddf5433168e"
    sha256 cellar: :any, monterey:       "0ae8564fad4510b9987eb42529b8b550d1b80834648d5a23d4f3b6f164e79d15"
    sha256               x86_64_linux:   "3e2dc2ca41c19053edbef4c19808943597e6eda7530dd894021e1b3e4178c508"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => [:build, :test]
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
    system "python3.12", "-c", "from gi.repository import HarfBuzz"
  end
end
