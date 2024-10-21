class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/refs/tags/10.0.1.tar.gz"
  sha256 "e7358ea86fe10fb9261931af6f010d4358dac64f7074420ca9bc94aae2bdd542"
  license "MIT"
  revision 1
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sequoia: "4a924069e0783e226a57ed0ce2f9b95d261f9a33b58f7810938d0624f5be9d4b"
    sha256 cellar: :any, arm64_sonoma:  "8b14b8bbc667af5a01a311e9928d7dac53770dd322731480f3e3ab65ea38f7ca"
    sha256 cellar: :any, arm64_ventura: "f98ec690b0fb7890beb4979de8c7705f6a3ea0aa255a464d64a399dc0c81fb59"
    sha256 cellar: :any, sonoma:        "b8590c108de2eca0ae5e6d92ab357f726f7143a020f14a4aa1c6da5aa637fa1f"
    sha256 cellar: :any, ventura:       "28516fdc43f471c1b7e8e85f9aa76276379e9341b51da0ddc338b635fb065994"
    sha256               x86_64_linux:  "82d5f95395dbaf51b6a561de5f931722f4a97d4899d44af032bd0afa30bc5edb"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "pygobject3" => :test
  depends_on "cairo"
  depends_on "freetype"
  depends_on "glib"
  depends_on "graphite2"
  depends_on "icu4c@75"

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
    system "python3.13", "-c", "from gi.repository import HarfBuzz"
  end
end
