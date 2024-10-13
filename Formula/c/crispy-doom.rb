class CrispyDoom < Formula
  desc "Limit-removing enhanced-resolution Doom source port based on Chocolate Doom"
  homepage "https://github.com/fabiangreffrath/crispy-doom"
  url "https://github.com/fabiangreffrath/crispy-doom/archive/refs/tags/crispy-doom-7.0.tar.gz"
  sha256 "25eea88fdbe1320ad0d1a3e0ed66ae8d985c39b79e442beab5fc36d9d5ddfc42"
  license "GPL-2.0-only"
  head "https://github.com/fabiangreffrath/crispy-doom.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "b9b035b756e9b42de763784b2d232e18edd11778a9417f61155011aafef3c03e"
    sha256 cellar: :any,                 arm64_sonoma:   "5c440e871b1498809e4372de33366c2c3df9e740bb8b541f9e414e4d96de50fe"
    sha256 cellar: :any,                 arm64_ventura:  "10f31a1dabdaa5709e63146e3ebb56008afce374116da948002b7e611b35f26b"
    sha256 cellar: :any,                 arm64_monterey: "327d92bb2cad988d5835718b372a77322f2aa7ba507200767e4d5dbb5c278545"
    sha256 cellar: :any,                 sonoma:         "325da8f1b4334a227d9f54f65434a84973331bec480d46e4136be618c32636b9"
    sha256 cellar: :any,                 ventura:        "edf187b019afbc43e5326413f87c603b591c964a1792932e3883e2a565ac0682"
    sha256 cellar: :any,                 monterey:       "b52ae717094041400af36ecbe0f741c7f32e7ec10c93f054f0e6d3a48d7e5c08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32038b4fcd8556a79441e0f482ea6597e1ae6a8ec934a415c7fadc62ed21cf22"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "libpng"
  depends_on "libsamplerate"
  depends_on "sdl2"
  depends_on "sdl2_mixer"
  depends_on "sdl2_net"

  uses_from_macos "zlib"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-sdltest"
    system "make", "install", "execgamesdir=#{bin}"
  end

  test do
    testdata = <<~EOS
      Invalid IWAD file
    EOS
    (testpath/"test_invalid.wad").write testdata

    expected_output = "Wad file test_invalid.wad doesn't have IWAD or PWAD id"
    assert_match expected_output, shell_output("#{bin}/crispy-doom -nogui -iwad test_invalid.wad 2>&1", 255)
  end
end
