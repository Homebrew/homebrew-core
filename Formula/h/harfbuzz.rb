class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/releases/download/13.2.1/harfbuzz-13.2.1.tar.xz"
  sha256 "6695da3eb7e1be0aa3092fe4d81433a33b47f4519259c759d729e3a9a55c1429"
  license "MIT"
  compatibility_version 1
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9d8422fa3f07df372e508585dd4565beb9840d6fedb1e3eab50df8731ef268c2"
    sha256 cellar: :any, arm64_sequoia: "c89965b0649295d187634cbeb101b2756a38afc5e33ec684d3a8ba5e142ff162"
    sha256 cellar: :any, arm64_sonoma:  "aa9c04d361a25894351df0797b24ea5e6625bc57c6913e7480bf822c13791fd0"
    sha256 cellar: :any, sonoma:        "d3c2db617ec38b61cf24ee0c3f032221e5f863040c571da009852ecb09f47edf"
    sha256               arm64_linux:   "bfb9d364fe5df167174a640c6b63cb2ed106368189e761fdb70033d966fec217"
    sha256               x86_64_linux:  "4efe593c84e32a7066b0a3f1f494af75b77d3bb71c54e9a9c97bcdcd53200126"
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
  depends_on "libpng"

  on_linux do
    depends_on "zlib-ng-compat"
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
