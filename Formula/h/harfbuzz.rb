class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/refs/tags/12.2.0.tar.gz"
  sha256 "f63fc519f150465bd0bdafcdf3d0e9c23474f4c474171cd515ea1b3a72c081fb"
  license "MIT"
  revision 1
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a1caa1a1114e025e6f08c6101ac97e1af5a1fea7cc9be71aeef86da2496460c0"
    sha256 cellar: :any, arm64_sequoia: "eda041888a074d2d00393d59078df013c287c88d6e11f75758201dfeab125943"
    sha256 cellar: :any, arm64_sonoma:  "545e8efb3299e245a4b40508a3c19a503675bffabdd052de4d1ec56ac52083cb"
    sha256 cellar: :any, sonoma:        "9439eebe18270431c9c1f3dfa1e907b94a19f1a3f9e82c6e9e38667bb95fd08a"
    sha256               arm64_linux:   "8ae536d8f129f61603d991a9fe87bb9eb670d190ece548fccc2ffb738b6b6dd5"
    sha256               x86_64_linux:  "3059b257b8ef6df09e3f73e49072f5901eaff4a99197a1412db13c291806389e"
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
