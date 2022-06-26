class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/4.3.0.tar.gz"
  sha256 "32184860ddc0b264ff95010e1c64e596bd746fe4c2e34014a1185340cdddeba6"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "f60423051df871df3587324817b8d0f3ee4e80d3ff8fd7362876e5eacb1319a2"
    sha256 cellar: :any, arm64_big_sur:  "c85635d41d343311ad030ab42e2c130bdd639cb45bd10cd7873c46983b19f902"
    sha256 cellar: :any, monterey:       "505a3697b4d5220856bd2df2d79f69e28652c037e84d784b77b5d1db6daf1ad1"
    sha256 cellar: :any, big_sur:        "1c7491c9c78f13ef72ee1535a6d5dab14c7873b030b35d60012e7279d604135e"
    sha256 cellar: :any, catalina:       "a9da619ad628d6080aa2f19d7b94c97bd2b3a09f7e616c640e812402a643cfca"
    sha256               x86_64_linux:   "f5975c60af6c00c66e0a15f581023c9197ac9d04f01fb1957580ec5927093f68"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cairo"
  depends_on "freetype"
  depends_on "glib"
  depends_on "gobject-introspection"
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
    ]

    mkdir "build" do
      system "meson", *std_meson_args, *args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    resource("homebrew-test-ttf").stage do
      shape = `echo 'സ്റ്റ്' | #{bin}/hb-shape 270b89df543a7e48e206a2d830c0e10e5265c630.ttf`.chomp
      assert_equal "[glyph201=0+1183|U0D4D=0+0]", shape
    end
  end
end
