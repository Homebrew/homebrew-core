class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/releases/download/15.2.0/harfbuzz-15.2.0.tar.xz"
  sha256 "e2ec49090744383cdbe7df808c1cedaafba06a97be8dc4211fe546ba585f12cb"
  license "MIT"
  compatibility_version 1
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    manifest_sha256 "2d2c9a4050250de84737b10fed4ea5754297f1f50236d7324f5fe48da6004d24"
    sha256 cellar: :any, arm64_golden_gate: "7880dae1bc51f51c14be6c2d7deae49b6ff82079dac12c8bca544cf3fe39f476"
    sha256 cellar: :any, arm64_tahoe:       "e3e72f48df09d84ff1cc5f7857c123f8ca89158374a206cc8d5f549558b6e1b6"
    sha256 cellar: :any, arm64_sequoia:     "2ff0502456c4f74bed13cba420f13e25e4ddf511f91259958eeda940df48475e"
    sha256 cellar: :any, arm64_linux:       "c3f9f6e2586025e24643c4bb94cd13e5ba8a1435950f5a96abb16dac091900b1"
    sha256 cellar: :any, x86_64_linux:      "e5286009da75d3d5584337ef66e85a150c4e61cdd2ecad50a9da95040b9ad301"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.15" => [:build, :test]
  depends_on "pygobject3" => :test
  depends_on "cairo"
  depends_on "freetype"
  depends_on "glib"
  depends_on "graphite2"
  depends_on "icu4c@79"
  depends_on "libpng"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "homebrew-test-ttf", :test do
    url "https://github.com/harfbuzz/harfbuzz/raw/fc0daafab0336b847ac14682e581a8838f36a0bf/test/shaping/fonts/sha1sum/270b89df543a7e48e206a2d830c0e10e5265c630.ttf"
    sha256 "9535d35dab9e002963eef56757c46881f6b3d3b27db24eefcc80929781856c77"
  end

  # downloads test resources
  allow_network_access! :test

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
    system python3, "-c", "from gi.repository import HarfBuzz"
  end
end
