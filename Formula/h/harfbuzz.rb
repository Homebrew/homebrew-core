class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/refs/tags/12.2.0.tar.gz"
  sha256 "f63fc519f150465bd0bdafcdf3d0e9c23474f4c474171cd515ea1b3a72c081fb"
  license "MIT"
  revision 1
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "82c55aff9f5145f1aafeb86b8634da44496b253d74a90f20b2a479bb4341134c"
    sha256 cellar: :any, arm64_sequoia: "57121f20ba41eaefc5d03ecb27bbf8358437d78e4c2e7d27b39b80588bf017ee"
    sha256 cellar: :any, arm64_sonoma:  "d61e8c35125bb0077e4b2adbd17f2cfacf680af29f392447832d36b68b582a8b"
    sha256 cellar: :any, sonoma:        "199cc741d17247a3e2293e08942bb6eee603de3068ef6669a636ab275d376cf5"
    sha256               arm64_linux:   "c2e3ed79377a79a13f23a65240e0dde91697c8fd952f78911c001b525453431d"
    sha256               x86_64_linux:  "8175667a6a9cb84cca005db53312eabc46b783b11817ef2a5ccd77672e02d429"
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
