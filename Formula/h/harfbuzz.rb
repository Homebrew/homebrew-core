class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/releases/download/12.3.2/harfbuzz-12.3.2.tar.xz"
  sha256 "6f6db164359a2da5a84ef826615b448b33e6306067ad829d85d5b0bf936f1bb8"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6e54f7723234f740cdffef930d08a5116792649588d4077dc35e43010143ade7"
    sha256 cellar: :any, arm64_sequoia: "9cc23dc48e3e05e22b911f324daa0c211f0af9c68009add5c614b9d6ec68f26e"
    sha256 cellar: :any, arm64_sonoma:  "cbe81ce2719e923562f0742869fd2eb5b9f83c39a8f0bc87a477300e82c7f986"
    sha256 cellar: :any, sonoma:        "b0eb4721c262c74a33e4d8ef121a6a85706962904caee23657f03069d60399b2"
    sha256               arm64_linux:   "a75bb468fb959551c35371005447291f765536bf7c8062db80539559f83defcf"
    sha256               x86_64_linux:  "95e744daa301690318b5e770b02ab97a88edadde8389fe094a403710537eef84"
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
