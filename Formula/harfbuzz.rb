class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/6.0.0.tar.gz"
  sha256 "6d753948587db3c7c3ba8cc4f8e6bf83f5c448d2591a9f7ec306467f3a4fe4fa"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "a0e742e4c20dc525b326a9595bf2346d61bba4a2d3c9f2a61d607e991fd2162f"
    sha256 cellar: :any, arm64_monterey: "9282efd9f5fb91d8d231a5add83c09899af2c544315f18e93c8cd5a82739ae58"
    sha256 cellar: :any, arm64_big_sur:  "72fd458735546d02509350ef807a6e33de5b12847af5c3e5040352b599da3b7c"
    sha256 cellar: :any, ventura:        "fa378e854c92d38870e5ab477b6eaefaa8271069da33e9a5ea43e80f1c84c850"
    sha256 cellar: :any, monterey:       "7859dfbb8543c23bbaa01363d4dcf56a859a543e4d780c06e3dd95d2bfe1e69e"
    sha256 cellar: :any, big_sur:        "695417c9be07d062ce28c05cafa2ca2a3c20038d029b028791ff75d16a079c43"
    sha256               x86_64_linux:   "c32bdcb5fea06cd010b4edbcc340392d69db613de0ff51e22ca62b735da5155f"
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
