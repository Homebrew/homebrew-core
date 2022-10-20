class CrispyDoom < Formula
  desc "Limit-removing enhanced-resolution Doom source port based on Chocolate Doom"
  homepage "https://github.com/fabiangreffrath/crispy-doom"
  url "https://github.com/fabiangreffrath/crispy-doom/archive/crispy-doom-5.12.0.tar.gz"
  sha256 "d85d6e76aa949385458b7702e6fb594996745b94032ffb13e1790376eeecb462"
  license "GPL-2.0-only"
  head "https://github.com/fabiangreffrath/crispy-doom.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8ef0f5533d93c92ad13fdb41baa49de8bb847d908b52ee7be13ab5ed5f4dbb1e"
    sha256 cellar: :any,                 arm64_big_sur:  "de4ceb6cb891d1938bc8dc2c0af97067891a5712a00105ee7a79a165f1982df2"
    sha256 cellar: :any,                 monterey:       "b0f2f38a431779e26c8ffda0fdee8b179a95268995cfefb78313a289062bdac8"
    sha256 cellar: :any,                 big_sur:        "80edc55a3986279b94dc13247bd3a7d3786cc5b81190ab6415accd842cd42873"
    sha256 cellar: :any,                 catalina:       "47f9599408b8f7bdfc0e4cb8083617c8a6f8aacd1d74287fca3d3d991148b5ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8b3f24dc327f6cad5ed387a418a4eaa0a87e258c3dce384466175c8b1323d21"
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
