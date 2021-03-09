class CrispyDoom < Formula
  desc "Limit-removing enhanced-resolution Doom source port based on Chocolate Doom"
  homepage "https://github.com/fabiangreffrath/crispy-doom"
  url "https://github.com/fabiangreffrath/crispy-doom/archive/crispy-doom-5.10.0.tar.gz"
  sha256 "0b6bac20816d057692e4f5c15dbbb27cc49e404e821f774e2b16ce997a6f3fe1"
  license "GPL-2.0-only"

  head "https://github.com/fabiangreffrath/crispy-doom"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2b5e266f3d833820c6f012714b82e025359a0f93b7a35ce0d69ca60a27dafdc0"
    sha256 cellar: :any, big_sur:       "dea4133cb1b8869964d77da2a9f1cf551868ef85320738f6588e866665938c95"
    sha256 cellar: :any, catalina:      "1b77f36d5151b7e5a627838a6fed8f559e147a9bd8c9d4d60fd7888c0fd06cf8"
    sha256 cellar: :any, mojave:        "72135b7e809104c36e71495432f7338c64ad6b1c861bc125bcc0c3bb4aac5ec0"
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
