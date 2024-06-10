class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/refs/tags/8.5.0.tar.gz"
  sha256 "7ad8e4e23ce776efb6a322f653978b3eb763128fd56a90252775edb9fd327956"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "27ef5184c6701225923ed823c9f142cb4c3da654c9c0411228694d022d3f9958"
    sha256 cellar: :any, arm64_ventura:  "577a436c50b9781051f192b6d2b582403577e9a9b7f371b3a8876d7681115572"
    sha256 cellar: :any, arm64_monterey: "df3b31872298cfdc1ef6f9160e5718e758447ddcbd98db02e9bab36a4e789de2"
    sha256 cellar: :any, sonoma:         "ce3db185a842341d92c1d11a18e37773e71534e3d5cf274cadfa49ebe1bef687"
    sha256 cellar: :any, ventura:        "7ad6e99d2aab379be5bc3925b7b55a2e2ece3d0effb8150b5cf8969cd265fd01"
    sha256 cellar: :any, monterey:       "1f4580cb1cb69ab2c2feffbdbba507d10f797d6a316f345448e91671954d702b"
    sha256               x86_64_linux:   "cea529ad4ff59ec2fdb40d9784ce1c041a7d99404e969d0a7a1fab6e4b458e57"
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
