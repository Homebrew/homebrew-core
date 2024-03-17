class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/refs/tags/8.3.1.tar.gz"
  sha256 "19a54fe9596f7a47c502549fce8e8a10978c697203774008cc173f8360b19a9a"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "0e769ab84fe5ac3263691fd4c6210b9c03754291e554f25d4ac2b18352c3d33a"
    sha256 cellar: :any, arm64_ventura:  "88f482d839673d5a2f9cada7559296cbd0bd57d5c7e8776fef768237fb75bbdd"
    sha256 cellar: :any, arm64_monterey: "7c4e555347d9f721f318620480fd1c659851c24187a29ffcc6d30335a5dab2bb"
    sha256 cellar: :any, sonoma:         "ada389775023260a277042cb63d68d83298f3a6cc492bbd6cad61aada47212ea"
    sha256 cellar: :any, ventura:        "a8fc4a3925af87f8299aa77c556b3dbce38cbd975975a6fda55a8107374f5de3"
    sha256 cellar: :any, monterey:       "7213dcef7c641afaa4a8f892d06fd8a17a422ad5c70e82188702f54ccc3a3a80"
    sha256               x86_64_linux:   "a28c0bf209615f4b55e3063af65bf7ba363de42c6880933576403d8eb98f2dc1"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => [:build, :test]
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
    system "python3.12", "-c", "from gi.repository import HarfBuzz"
  end
end
