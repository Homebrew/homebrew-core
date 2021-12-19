class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/3.2.0.tar.gz"
  sha256 "41b38daa13ebdba39fae3b5fb2abbf5f9ccd9121bfa7f47b18d51aa733f80aad"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "f85847aa398b826ceadaec1745e256eb0e7d8df8dd162dd0812879ccb76f5635"
    sha256 cellar: :any, arm64_big_sur:  "42958059b98d0199db63b0f7d61674cbec689826f636cdafd944406a55046526"
    sha256 cellar: :any, monterey:       "d83be22448c146f8dee5b6dfa911ba0097da22235217791d4cbac7381416ce92"
    sha256 cellar: :any, big_sur:        "a7b38465eb9da30e14c80664dba0d1a3bbb971b5e3086e6c4694f0c5da8dd718"
    sha256 cellar: :any, catalina:       "a1271e791db27529ee0cc2f378ea37f9161dd280bf34aff78c35da1f98ceefc6"
    sha256               x86_64_linux:   "1f15fee5fe30ebc86f4b66d3713dd318ac212542b21c7e4eb0daec2b58ac7e41"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cairo"
  depends_on "freetype"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "graphite2"
  depends_on "icu4c"

  resource "ttf" do
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

    mkdir "build" do
      system "meson", *std_meson_args, *args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    resource("ttf").stage do
      shape = `echo 'സ്റ്റ്' | #{bin}/hb-shape 270b89df543a7e48e206a2d830c0e10e5265c630.ttf`.chomp
      assert_equal "[glyph201=0+1183|U0D4D=0+0]", shape
    end
  end
end
