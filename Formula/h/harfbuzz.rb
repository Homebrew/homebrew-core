class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/8.1.1.tar.gz"
  sha256 "b16e6bc0fc7e6a218583f40c7d201771f2e3072f85ef6e9217b36c1dc6b2aa25"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "8849b51933258f8135ca000b7125beffb8dd5d95673be2711648167459bacdf5"
    sha256 cellar: :any, arm64_monterey: "b824a4b0c867eb4bebc0d04a2459811d375cac4c9e7fe6094250e06e53a67e73"
    sha256 cellar: :any, arm64_big_sur:  "66684ae1c427829fa18233e9eb369fdf6692cb2b60bf068175d795d8b776a634"
    sha256 cellar: :any, ventura:        "4567b4adb3d3fd962fd90333bfeaa5ed25fd2e6fb8945ff415b4e458056663e8"
    sha256 cellar: :any, monterey:       "39d2810ab74ba2e7698e3a60362eb52d9475c65de5f96a4ae528f2db8578f063"
    sha256 cellar: :any, big_sur:        "e360a22417104fbc0a2ea60cd9ec35b766cc38f3b3eab822bad372beb8e9647a"
    sha256               x86_64_linux:   "6e559f1a884be190a99b8d9942156e15f459d330d269219d3979b9930e5db290"
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
