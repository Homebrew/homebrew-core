class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/refs/tags/11.0.1.tar.gz"
  sha256 "c9cd31190f4b2845937899df3035b3f9b2f775cbe76a6051be60411e59639d45"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "c4f555002b70ae707d81d2e0bc6ae6abacf02d3f4a4d9d8f156c9020b60d4971"
    sha256 cellar: :any, arm64_sonoma:  "0c7e2e51ceabb296f0e4a4587e4c9b98525a1bd0f6c2b0b389e3fa052ccc05d1"
    sha256 cellar: :any, arm64_ventura: "20b8f5d4cde72d02e467f78fb84c9ae147171ec6e52135847b13a180a0435cc7"
    sha256 cellar: :any, sonoma:        "9f71adfbf73652f8c110d3f794da491fae86fd42bbef9d235dcecbdaf8100351"
    sha256 cellar: :any, ventura:       "f6aeaefc769889789a5470a0e759b4c55774757f0d15719e1535066513c86394"
    sha256               arm64_linux:   "032edd8b596c8781ae6835d874c45bedb881e4241f4dbdd2c697e129cd050b7b"
    sha256               x86_64_linux:  "329d5a181a9ab0def51bb4487e103e12d5125d16e5215f7772296a4e37527cd1"
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
