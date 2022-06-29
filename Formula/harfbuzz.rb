class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  stable do
    url "https://github.com/harfbuzz/harfbuzz/archive/4.4.1.tar.gz"
    sha256 "1a95b091a40546a211b6f38a65ccd0950fa5be38d95c77b5c4fa245130b418e1"

    # Fix build on GCC <7, remove on next release.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/ae5613e951257f508f4b17e9e24a3ea2ccb43a3f/harfbuzz/fix-pregcc7-build.patch"
      sha256 "17abbae47e09a0daa3f5afa5f6ba37353db00c2f0fe025a014856d8b023672b6"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "ac805625a6a531cd49941e438734d1d04047468b258e13a9c69b49ffe8c2d6e9"
    sha256 cellar: :any, arm64_big_sur:  "8c01600430f55f789ab84bda5b849db34c546af2aa148d7b5cf01773cb19cd1b"
    sha256 cellar: :any, monterey:       "377f6421e16e3a02f404a7102e289d6b45922d0e98fb7622bcab096d9a2cea71"
    sha256 cellar: :any, big_sur:        "c29882b20e5b2470089e52468d3f9d5903c28a4cd1bdf2486b6f183f4acdd6f3"
    sha256 cellar: :any, catalina:       "40458e121e35d8524ead05fe2cff7832887126ff89f7a9282ffbe513eb77c646"
    sha256               x86_64_linux:   "b908b03f51fb681ffb37d5d18493b3f9954dfeec07808f5706f25511172822fb"
  end

  depends_on "glib-utils" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cairo"
  depends_on "freetype"
  depends_on "glib"
  depends_on "gobject-introspection"
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

    mkdir "build" do
      system "meson", *std_meson_args, *args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    resource("homebrew-test-ttf").stage do
      shape = `echo 'സ്റ്റ്' | #{bin}/hb-shape 270b89df543a7e48e206a2d830c0e10e5265c630.ttf`.chomp
      assert_equal "[glyph201=0+1183|U0D4D=0+0]", shape
    end
  end
end
