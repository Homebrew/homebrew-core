class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/refs/tags/12.0.0.tar.gz"
  sha256 "c4a398539c3e0fdc9a82dfe7824d0438cae78c1e2124e7c6ada3dfa600cdb6c8"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e060b310fc432499215f37ff759bb1fe2c7b8c1f45eb18b9540f1274920caef2"
    sha256 cellar: :any, arm64_sequoia: "52dd2a5ed6b81feee26baff0d7f7f7ad4ebbbb291a29c444cc16ad40540f04a9"
    sha256 cellar: :any, arm64_sonoma:  "e7671d84f479cd0f1fefb228dce3600a79e726fb23bf0571e81cd1d40deb531e"
    sha256 cellar: :any, sonoma:        "ef2ebfb21a48a573491df86ba7fd9e0fcf180c066ce590899aee46b1c67dbf87"
    sha256               arm64_linux:   "b17253cfddd836d393581d9c7f6a481915251a79f641b7c4f3c53b505f9e9747"
    sha256               x86_64_linux:  "0b2b1a368d3bbd1740e819cf5e798b974ccebf731223f9d46177cb343f2e6908"
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
