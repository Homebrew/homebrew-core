class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/refs/tags/8.3.1.tar.gz"
  sha256 "19a54fe9596f7a47c502549fce8e8a10978c697203774008cc173f8360b19a9a"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "d098aead5acc3e34d16a39a38e62d04655c64c3e713fe6e69b44d399bb2dd3c2"
    sha256 cellar: :any, arm64_ventura:  "31f450c8cc60b0282f23c8460dce2e76be67fca80056026f8e79b681c1069470"
    sha256 cellar: :any, arm64_monterey: "0f00eac2bbf947636008d59bd01adacb325f60f5309b7be9ffa885180df6a258"
    sha256 cellar: :any, sonoma:         "32706b53a72d4513d6c21c00495e3e09762fe01d05b83b83e63698b665837b4e"
    sha256 cellar: :any, ventura:        "afaa45911efbefe21af82441817d747e91156b40c87ad2117f07de94094dbb93"
    sha256 cellar: :any, monterey:       "9e8ad480cc6555083d90b24a6290fbebdacdf016ce7cf132dd5646afb7cc006c"
    sha256               x86_64_linux:   "b6f063b59372bcbe5064b4cd0b3fc4323d65ae8220c1a6b7220a01be7cb2f294"
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
