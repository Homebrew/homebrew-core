class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/7.3.0.tar.gz"
  sha256 "7cefc6cc161e9d5c88210dafc43bc733ca3e383fd3dd4f1e6178f81bd41cfaae"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "d90cb3296c384be492f91d0b43d28367061ceb3c0a1d413342056d46e3e10aeb"
    sha256 cellar: :any, arm64_monterey: "fd5965f09a39f11ae089f08a4dcdbfec00ea6a1d6512e761f9462ce89fca04d7"
    sha256 cellar: :any, arm64_big_sur:  "2a66a9821b26a2b95f2066ff54c6326e90f1439923377e56ff5fa5f91d2341c8"
    sha256 cellar: :any, ventura:        "79eda4e3c0a3e64ceb127493ed8b177b68270e2652e9bdd022d8db06ff703638"
    sha256 cellar: :any, monterey:       "1a872fb4b8c14e4f2940f6baebcd976e76b651cde5627a8cc4ce5ccc191875f3"
    sha256 cellar: :any, big_sur:        "b6cf02a673e34f4e547a0878c4068bf6d7d3cfed824662e941a7acef5ebd6393"
    sha256               x86_64_linux:   "1ba2d9070aa29f5d243f40a056bd287f8a4922c27881c85204ad5667c2687bd4"
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
