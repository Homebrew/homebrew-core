class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/refs/tags/8.4.0.tar.gz"
  sha256 "9f1ca089813b05944ad1ce8c7e018213026d35dc9bab480a21eb876838396556"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "b74301ad74f8d0647b49ed72156895d0c598d7cf206d331d79aeab415eb72e8e"
    sha256 cellar: :any, arm64_ventura:  "dee14c98e92282e71af1487682ac7121db23ad88f9d7e5e2a358ec84ab3812a4"
    sha256 cellar: :any, arm64_monterey: "38c193a00a70eaf5893961353b12f356e3ca92eb1ba52d1dc8153c56a3c21184"
    sha256 cellar: :any, sonoma:         "2be9787ee914184a146b99eaf28fd3367ce487a5ff685b7cb6266022d8badd51"
    sha256 cellar: :any, ventura:        "c347ae63119c1d8484f7711a17d8973f50194c215970b3ecccbfba186f70cce8"
    sha256 cellar: :any, monterey:       "f2827c339eb5fbcfdcd3846e955a3b5dbebdeb36ec8b9f30c1bd2476df0fc69c"
    sha256               x86_64_linux:   "9bfb3b0736a1b4bb904f742b72abccdcc74a90c9b4344d44a314714b8a8ae51d"
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
