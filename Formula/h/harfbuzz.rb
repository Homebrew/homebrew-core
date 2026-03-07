class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/releases/download/13.0.1/harfbuzz-13.0.1.tar.xz"
  sha256 "3553d943401c34ab9b8c75f35cdb8452ca660233b0e9d4a22395ce5245484bd7"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bda151a1bfbf79907da734748c575a71ec1c1ff2334b44d4caa249176eb7181a"
    sha256 cellar: :any, arm64_sequoia: "0020be4796abc931cd5337d2ef841bc2c0da1414b6617868ab1e605bd07d65d0"
    sha256 cellar: :any, arm64_sonoma:  "6ef50f8fb730ae17ee407ac9ff1b527a146913a7c1d1cbd0deccaeb6fe0ee211"
    sha256 cellar: :any, sonoma:        "cb5325b3c3d088fdec3168788c62dc0bb0df909875749a59417696fab4b462cd"
    sha256               arm64_linux:   "80e87c26e6aaf58d6dfb1e1eaf37d93f2b739269fda1af2534b9ed17b139505f"
    sha256               x86_64_linux:  "129751a82e917f40df5d13b1fe2a21d2b0e322d0e814a60eca43d48539e5262e"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "pygobject3" => :test
  depends_on "cairo"
  depends_on "freetype"
  depends_on "glib"
  depends_on "graphite2"
  depends_on "icu4c@78"

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
    system "python3.14", "-c", "from gi.repository import HarfBuzz"
  end
end
