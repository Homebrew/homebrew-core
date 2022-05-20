class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/4.2.1.tar.gz"
  sha256 "99fcd30e2f4c66d05af3d61ad4cdba2abc2a51ecabb7eb6dc222520a892b50b0"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "0d08283d719f92e249e8839539642c0e56b4b92ca945ef4fed0d639e526e6020"
    sha256 cellar: :any, arm64_big_sur:  "2bc8f1102a78a60e59d24146ace859c2dff2e78d3181374ad90a4a738f28fd77"
    sha256 cellar: :any, monterey:       "5bdd586cefe1c6cac66ca14783918bdc4d82927923958ed3b64bb2a4e36a1481"
    sha256 cellar: :any, big_sur:        "d6a5c5591e176cbc1702387678cb8a1ba9ab3f50a0407de6e196dfd6241925c3"
    sha256 cellar: :any, catalina:       "5d5da7a6cadb6183c709d5cfa504f331a1d05eb1abbdb7107240aaf3b252f79c"
    sha256               x86_64_linux:   "6dd16ab7c63f64b035fe1d1b33cbe3e6094fddc0e160c2d6a75b284e0c7ed6b9"
  end

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
