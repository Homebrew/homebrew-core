class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/releases/download/15.1.0/harfbuzz-15.1.0.tar.xz"
  sha256 "0fc7c565443a5f4be7da65ac5ee5bd737d9b158dc908708b7689a0a5796b0c8d"
  license "MIT"
  compatibility_version 1
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "474e9c051ca409ef2cca1c24db98816809d0dd50ae216838508a3e5be1062f85"
    sha256 cellar: :any, arm64_tahoe:       "e465d30dc1fc03012d5bff48ce6452c4cc411392de11830d4743ebc739ef02e5"
    sha256 cellar: :any, arm64_sequoia:     "a6286d242e42731cef8f3e4ad20bff6e45146c4235693cbfc0db73242ca9cc7e"
    sha256 cellar: :any, arm64_linux:       "a2eeaf19441ac36affb2aa7f986df5993be4e94900145613755cf4864e5927c8"
    sha256 cellar: :any, x86_64_linux:      "5389ca68e50532aeddbf7b831c4d1f4ae78ed33a7ec39f4a517033193206da6b"
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
