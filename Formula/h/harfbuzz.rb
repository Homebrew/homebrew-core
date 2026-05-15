class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/releases/download/14.2.0/harfbuzz-14.2.0.tar.xz"
  sha256 "94017020f96d025bb66ae91574e4cf334bcad23e8175a8a40565b3721bc2eaff"
  license "MIT"
  compatibility_version 1
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b3599c1acc8c22d11d5cbe845bc081834d951c7c587c5d0e70b1eceb031fbd5f"
    sha256 cellar: :any, arm64_sequoia: "1360930f6ba10b1aac593ecdf8aaf5a4862f3a2824117426c81b31bcda51855f"
    sha256 cellar: :any, arm64_sonoma:  "42c1c6e3277d2b1d72a9c0d804e25faf0c59402ef96ddaadf008f99f816860b5"
    sha256 cellar: :any, sonoma:        "74fcf96d33f9d4c94189da94b38b661166bed74d88076f2b0f51811d9732afc1"
    sha256               arm64_linux:   "8af3aa5ff7b7aff459095e290f324b5ceff33e2478063cad53a1aa8be1579719"
    sha256               x86_64_linux:  "1c68860e96073c0349a0ec473badbf2516874c703da004474b9f0c75e8a8c0bd"
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
