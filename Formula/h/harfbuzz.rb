class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/refs/tags/12.1.0.tar.gz"
  sha256 "0238bf7ada6b1fb92984f69f8b9cd66518af83cf24f7db1cfe60c772c42312d3"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "16bf5f072611a61042b8876425600d2d3555afb8d37bfd7b46d03be1dbd3db32"
    sha256 cellar: :any, arm64_sequoia: "d04d381a5f8f01a904e330415aca2953f73dd97b51cc39d836b2391d6431a748"
    sha256 cellar: :any, arm64_sonoma:  "46c62445bcda9468877830a6bc482135ffba17cce546b76b1a7482a172f32dff"
    sha256 cellar: :any, sonoma:        "8d10a3360c488f85fa50aa4d2aa33d8f709ecae0726fb6715c72703ff25cf1d4"
    sha256               arm64_linux:   "d19a7955d0e83b43a44678864af12fcdc745759cad4b75f8f797522b43f368b2"
    sha256               x86_64_linux:  "697a16864ae6c160a27710abcbbe8be5a188ec8a857043e0ad62680f4028edaf"
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
