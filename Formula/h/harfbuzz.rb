class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/refs/tags/10.4.0.tar.gz"
  sha256 "0d25a3f74af4e8744700ac19050af5a80ae330378a5802a5cd71e523bb6fda1f"
  license "MIT"
  revision 1
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "3f8f12c182943f1c4215b3bae44d0d729fd478620a89b9f4e04ad79b8eb740a0"
    sha256 cellar: :any, arm64_sonoma:  "d6447b24ab9a09b194b5cabe6b44b8370b0ef057fa85598de7da59a0509fe933"
    sha256 cellar: :any, arm64_ventura: "8d8f1cffd8c8d1c9df5a725547dc0513f5d33056e95ebaeb5de7093b941f7d86"
    sha256 cellar: :any, sonoma:        "09f649229b223a7da6ae9a6c289fe71bbc29c9988ab2e2d494abf8bf804f4ebf"
    sha256 cellar: :any, ventura:       "d919d1cc95e7350ec2fb90e7f6fd6e916e6ba36d0b24dfb8242af49eefa7850c"
    sha256               x86_64_linux:  "d54b29388e61e7247401c1c24436aa58b1a5f15bb36ab85339d530ff35adc853"
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
