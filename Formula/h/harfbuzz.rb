class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/releases/download/14.4.0/harfbuzz-14.4.0.tar.xz"
  sha256 "2357ed966c6ced7bfa720b0640c0231065af01158fbea215093ffa15aed44371"
  license "MIT"
  compatibility_version 1
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "05cf5776d8e75b155c6630532b8018a37a2fb56321ade7d46b70804ee23357a6"
    sha256 cellar: :any, arm64_sequoia: "673d5f7f753ec7529960f06366adfb4b6f896e7eff6ce7fe8ab2626f8b5c3a57"
    sha256 cellar: :any, arm64_sonoma:  "7beae4366dbd6d7ea9422263d0e9c916fdd1e6ff0ac9fea9219f8137b6685f1a"
    sha256 cellar: :any, sonoma:        "f8d05176830f2a7dc5aa1c3a4e271515f798353cf2891c7d33b1717b543482d1"
    sha256 cellar: :any, arm64_linux:   "2602b71e3df29d5a80f0885b8ba3f49707e1987733939e8231d307d8c2300c95"
    sha256 cellar: :any, x86_64_linux:  "600ff248f89101b59d77be239bcac2a8262e32a0d4175bd99ec18b566391907f"
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
    resource "homebrew-test-ttf" do
      url "https://github.com/harfbuzz/harfbuzz/raw/fc0daafab0336b847ac14682e581a8838f36a0bf/test/shaping/fonts/sha1sum/270b89df543a7e48e206a2d830c0e10e5265c630.ttf"
      sha256 "9535d35dab9e002963eef56757c46881f6b3d3b27db24eefcc80929781856c77"
    end

    resource("homebrew-test-ttf").stage do
      shape = pipe_output("#{bin}/hb-shape 270b89df543a7e48e206a2d830c0e10e5265c630.ttf", "സ്റ്റ്").chomp
      assert_equal "[glyph201=0+1183|U0D4D=0+0]", shape
    end
    system python3, "-c", "from gi.repository import HarfBuzz"
  end
end
