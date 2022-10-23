class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/5.3.1.tar.gz"
  sha256 "77c8c903f4539b050a6d3a5be79705c7ccf7b1cb66d68152a651486e261edbd2"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "bd01909faec051992aeaa2502fe4edf4337db65ba05f225b23f9301a00c114b6"
    sha256 cellar: :any, arm64_monterey: "803fcb07d34c251e167a73bceaaf67767cd46ac0e78abd29decd4a6f8ddac726"
    sha256 cellar: :any, arm64_big_sur:  "d7b50e0495c29f6982184114efc333ced03da42ab324f22751d95def09b39e19"
    sha256 cellar: :any, monterey:       "6f5a6b534c5888351a448dc08aa3ad81c3c28492bc9973fc614499b59cb93ca0"
    sha256 cellar: :any, big_sur:        "62ef95057017aa1f0bebf8a498be1ef627fa97df6da68e68ac76b808d4e6e59b"
    sha256 cellar: :any, catalina:       "3461b999cc876ba677f5d3da267807b052ee5d954a0b961568b58d6517089017"
    sha256               x86_64_linux:   "d748dc18e351589c2d0a60f41b49b1c10ef839d48533e03ce392f870b1d3e5b3"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.10" => [:build, :test]
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
    ]

    system "meson", "setup", "build", *std_meson_args, *args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    resource("homebrew-test-ttf").stage do
      shape = `echo 'സ്റ്റ്' | #{bin}/hb-shape 270b89df543a7e48e206a2d830c0e10e5265c630.ttf`.chomp
      assert_equal "[glyph201=0+1183|U0D4D=0+0]", shape
    end
    system "python3.10", "-c", "from gi.repository import HarfBuzz"
  end
end
