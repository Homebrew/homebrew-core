class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/8.1.1.tar.gz"
  sha256 "b16e6bc0fc7e6a218583f40c7d201771f2e3072f85ef6e9217b36c1dc6b2aa25"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_ventura:  "3361cde4f04e5ad011bc02226b6434956328347d2396ff7b2ce86ba40a1b493b"
    sha256 cellar: :any, arm64_monterey: "49e9a380544fd2243c49724b7b469deecf3bfc00624e93d7225f1e31ba21fdcd"
    sha256 cellar: :any, arm64_big_sur:  "5d0964a9b6e3cadd18ace958e6462a05717cb9e403092b2370a217f90fab51dd"
    sha256 cellar: :any, ventura:        "63cbc1ed67588fb8c53e39c34c175f5d7f5e02381eaa7f783dbad28b49497f66"
    sha256 cellar: :any, monterey:       "28e115324ac6d54f11d1f0d8b2a757df098a770a3c5bcd0eafeb18bb6c3d701b"
    sha256 cellar: :any, big_sur:        "20d7ff0fb2a862d2782e88445572e29f4104dcdc37c42ed4d7eaf3d5d0db1168"
    sha256               x86_64_linux:   "c4327a1000c5318128cff5e75cdcd304663d3817fbffc65cd09a066778348f00"
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
