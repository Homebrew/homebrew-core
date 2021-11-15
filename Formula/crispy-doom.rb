class CrispyDoom < Formula
  desc "Limit-removing enhanced-resolution Doom source port based on Chocolate Doom"
  homepage "https://github.com/fabiangreffrath/crispy-doom"
  url "https://github.com/fabiangreffrath/crispy-doom/archive/crispy-doom-5.10.3.tar.gz"
  sha256 "eef8dc26e8952b23717be3b20239fda4ee59842511328387766d1c8fe8252f6b"
  license "GPL-2.0-only"
  head "https://github.com/fabiangreffrath/crispy-doom.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "06236817abc6d69fec168a719edafd7196908f1610359228bf74894fae7b86f7"
    sha256 cellar: :any,                 arm64_big_sur:  "6d9000bd5ee7e800eecf8748c419ea4f8d42dc1e5c78ec5e49e91ab095e34895"
    sha256 cellar: :any,                 monterey:       "ae6437bd7678cdfb5a4ac4f318126d1f089f9a74105efa267b008a2451bc7b5b"
    sha256 cellar: :any,                 big_sur:        "cbd514df66ecb0eb170169ce1f099fedefafa17f79cdeb2dfe00120d7e2fa03a"
    sha256 cellar: :any,                 catalina:       "07ab97bfe589f66a63007f32ab6f5a937aec221fb3528ab33259fc3c6652bb60"
    sha256 cellar: :any,                 mojave:         "ae4f7e635129aa417d47826af76123678ae786c0889b4baad08c59b3c730c36a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef1289f3ed451a8f7c301f9e56446139d349e9664f4be42c0858d082e148f935"
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
