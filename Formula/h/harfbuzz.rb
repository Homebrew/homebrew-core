class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/refs/tags/11.2.1.tar.gz"
  sha256 "057d5754c3ac0c499bbf4d729d52acf134c7bb4ba8868ba22e84ae96bc272816"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "c2bfac8d26f33150c1fbe86293113c217b6a452c347a509428f3a7ee4752b956"
    sha256 cellar: :any, arm64_sonoma:  "509842a43792ef0fac0bc55a0cffd4eb424ae91ea576de4bb58903c787913986"
    sha256 cellar: :any, arm64_ventura: "f3f560cff261aaf4d8f6adb7312673d85b4bddec40a1ecad7ee9c618998aa09f"
    sha256 cellar: :any, sonoma:        "fa2402380d3f6f5f3c9aa13ea3414c49ffba1f7f243ca78a77e761eabd6beb34"
    sha256 cellar: :any, ventura:       "d61d888fc759b1ed1ee9e1d7b72fc0668425f55979b800823d809efaba8ca112"
    sha256               arm64_linux:   "b531487da9f408317fcf04ec5101a12b089e52ac85b960a4e76c8800c083a3ed"
    sha256               x86_64_linux:  "a3c3cee38367d44e713a98a09e117cd831cad5c67fb52fe67d75a81450b9d94a"
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
