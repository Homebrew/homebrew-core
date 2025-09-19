class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/refs/tags/11.5.0.tar.gz"
  sha256 "119778e3a692806e45104b2cdfda807a8df2ccf5421c50a016aa4b7b82260205"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "883da48002d2cfae4c44c5b43be274967893fa39fee379267acc83d32784df53"
    sha256 cellar: :any, arm64_sequoia: "291666fda455cbfc2ccc13a3919597951887995f75a80b8959a691467504809a"
    sha256 cellar: :any, arm64_sonoma:  "b58fb86782db3571bb0a38aa07cde995743fbb97fd74e4e71174e0a4dd92d822"
    sha256 cellar: :any, sonoma:        "7fcb20a99b2359ff3012280e2fd18d9fc09e6d05506080e527f22f05ecf9189b"
    sha256               arm64_linux:   "2ece0d076155032d356ffc6023d1d9e4ef372a9756aac10c852430e014633370"
    sha256               x86_64_linux:  "a68e16bba62a8d904012db831ea03a8d2dea10ea369ffce1dbb08f2cfc509655"
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
