class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/refs/tags/11.1.0.tar.gz"
  sha256 "0342d39eb802e5b0d9f319edf7a8b3d9a814c94e0df5711d646cf7ab6e29288d"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "02ebf18df75fa41c143ce55ba0685681c76ec0dbc2d687a2b6ea097fcc69eaa6"
    sha256 cellar: :any, arm64_sonoma:  "2c0acf4239260878cd9aad5d6aba32b1358614c31fb897ab9bc5c053d922de9c"
    sha256 cellar: :any, arm64_ventura: "c98603d28a36e02404603aab8c217f37bee888826dd7d6f5c0149e83a8f8e3d7"
    sha256 cellar: :any, sonoma:        "48ea1d90d2a92c539472d8585606a37e3cb8df4ad3dbe577751db8eaba80c55e"
    sha256 cellar: :any, ventura:       "daf3c1b7c5568a3e73072115a40404f30b39d6bbdca2698782069f8dc264b74c"
    sha256               arm64_linux:   "f3f834cf1bb1648b425655c7b41fa677f5293f791d10202a9b870f2567271dba"
    sha256               x86_64_linux:  "91bbbf4e8ebf9bd98d7f364b8ea38009605af3e55eaed5864d9c6624c02dd629"
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

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    resource("homebrew-test-ttf").stage do
      shape = pipe_output("#{bin}/hb-shape 270b89df543a7e48e206a2d830c0e10e5265c630.ttf", "സ്റ്റ്").chomp
      assert_equal "[glyph201=0+1183|U0D4D=0+0]", shape
    end
    system "python3.13", "-c", "from gi.repository import HarfBuzz"
  end
end
