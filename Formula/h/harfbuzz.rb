class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/refs/tags/11.2.0.tar.gz"
  sha256 "16c0204704f3ebeed057aba100fe7db18d71035505cb10e595ea33d346457fc8"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "546c301c29fc48740f82b9d2202d39ae0ee8e6f835daf1bc6aec6e9503806f7b"
    sha256 cellar: :any, arm64_sonoma:  "5a69b227896c824e52aa734b0645083da9fd70739cb795e51897d312dbf92f08"
    sha256 cellar: :any, arm64_ventura: "b10a408d6ed82ceb154de15010808e2820c8e2f8ebf4baa47908f161e42ff05f"
    sha256 cellar: :any, sonoma:        "ca9e8cfc6a6d015f817ed688f5ed9a88eaec664cfefc718703623ecfe48f8b4c"
    sha256 cellar: :any, ventura:       "9eee3faa7b27a93b4d8baa262995213af707fd9fb5575fada010d718b638b7e3"
    sha256               arm64_linux:   "b5c1731cf04293ff7b8869bdf8ca3f6de4c65f1239a9e6e75b7e95a2093b40c3"
    sha256               x86_64_linux:  "0aa988712520c9a1b2ea9995c9e6b77ff72b04a2313ee264f68e33f85a3115c0"
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
