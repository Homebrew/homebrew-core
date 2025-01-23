class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/refs/tags/10.2.0.tar.gz"
  sha256 "11749926914fd488e08e744538f19329332487a6243eec39ef3c63efa154a578"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "2f892566c02b3c8c61aed6f7867b4405e5c814df8500ef4bc4ca91a9e40205a9"
    sha256 cellar: :any, arm64_sonoma:  "7e45cdf77d0075ca8846705117fbd7d0d4347be7cb5e70d4217cb6370c544d30"
    sha256 cellar: :any, arm64_ventura: "c1505a6c464b37105870942ef48e4ace43fc8fbece25a4090d0eda8cd0edca90"
    sha256 cellar: :any, sonoma:        "47e78617927dd3b420d594ea9fe6fef726a48303e9e72fdf2b0389511536b415"
    sha256 cellar: :any, ventura:       "cce3d593465989e13ced6520793a46cc91df5e8564137718da3660a2a20de2fb"
    sha256               x86_64_linux:  "bf897ae518595d23361a7d5787212c4557c8ac0d015a0d2fea132e964d57ee62"
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
  depends_on "icu4c@76"

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

    system "meson", "setup", "build", *args, *std_meson_args
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
