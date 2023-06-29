class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/7.3.0.tar.gz"
  sha256 "7cefc6cc161e9d5c88210dafc43bc733ca3e383fd3dd4f1e6178f81bd41cfaae"
  license "MIT"
  revision 1
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "4ff40bff874789528ce27fbba3f7413ecfab35a338c7a7b98c67c25900a23401"
    sha256 cellar: :any, arm64_monterey: "807d05d6f61093a24e46d8ec5359c711af1077b47cf3b25ed10a6eab4a644ad5"
    sha256 cellar: :any, arm64_big_sur:  "5374fcd4378d6561c4c213f69b7a41edbdd4e7d0739b37951b6efe53f0ffb915"
    sha256 cellar: :any, ventura:        "ab02261d368f2d3e176b147ef4c93b54c114c799cb9fcaec608bd4c87858ef36"
    sha256 cellar: :any, monterey:       "23578a9dc75025290efbfdfcc628ea430205dcfcb54572eb2ad3c5d64c21db91"
    sha256 cellar: :any, big_sur:        "b59130fcc25f4cc7ed063e1f22f92789b2dc47f4c7072ecf99e5a811bddf12d5"
    sha256               x86_64_linux:   "777354a89d435da7533f6348d021aee4f87e96d582842e7fb7a7ad3324fa439e"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "pygobject3" => :test
  depends_on "cairo"
  depends_on "freetype"
  depends_on "glib"
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
    system "python3.11", "-c", "from gi.repository import HarfBuzz"
  end
end
