class CrispyDoom < Formula
  desc "Limit-removing enhanced-resolution Doom source port based on Chocolate Doom"
  homepage "https://github.com/fabiangreffrath/crispy-doom"
  url "https://github.com/fabiangreffrath/crispy-doom/archive/crispy-doom-5.11.1.tar.gz"
  sha256 "7c5bb36393dec39b9732e53963dadd6bcc3bd193370c4ec5b1c0121df3b38faa"
  license "GPL-2.0-only"
  head "https://github.com/fabiangreffrath/crispy-doom.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "62424f03d1719164f319e10f34ec766e2658f27d7cabac13de13495942a7945f"
    sha256 cellar: :any,                 arm64_big_sur:  "55ce1400ac1900297819b41649b54737d7c35e91c3d5320de35211f59bd4683a"
    sha256 cellar: :any,                 monterey:       "50b73994eb25420223433d3dd274514d1d09afa26df795011b05e75b4c45713e"
    sha256 cellar: :any,                 big_sur:        "0a6c4fa39687a9a3fe2637001bb9f99f67fce0d5616e1f49cab9567a8cc252f2"
    sha256 cellar: :any,                 catalina:       "13340eeb2e02f30cdb97f1866f78844119b2c54b04986571775622aef6b1cf70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c28c1f1a20d791a543bae547d50abb94f7449d7f0b47f5b196b0b9a1046defd"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libpng"
  depends_on "libsamplerate"
  depends_on "sdl2"
  depends_on "sdl2_mixer"
  depends_on "sdl2_net"

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
      Inavlid IWAD file
    EOS
    (testpath/"test_invalid.wad").write testdata

    expected_output = "Wad file test_invalid.wad doesn't have IWAD or PWAD id"
    assert_match expected_output, shell_output("#{bin}/crispy-doom -nogui -iwad test_invalid.wad 2>&1", 255)
  end
end
