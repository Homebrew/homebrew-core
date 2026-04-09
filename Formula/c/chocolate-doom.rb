class ChocolateDoom < Formula
  desc "Accurate source port of Doom"
  homepage "https://www.chocolate-doom.org/"
  url "https://github.com/chocolate-doom/chocolate-doom/archive/refs/tags/chocolate-doom-3.1.1.tar.gz"
  sha256 "1edcc41254bdc194beb0d33e267fae306556c4d24110a1d3d3f865717f25da23"
  license "GPL-2.0-only"
  head "https://github.com/chocolate-doom/chocolate-doom.git", branch: "master"

  livecheck do
    url :stable
    regex(/^chocolate-doom[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c2c512540ff8466c3ce24619831d65d9890388c6489c3cfa448e688a7ca0084e"
    sha256 cellar: :any,                 arm64_sequoia: "bec38408dc088130d0e681ec1820f8f921ecf57bcbacf74732a619036451c5eb"
    sha256 cellar: :any,                 arm64_sonoma:  "7cdb454c4ab4b9cf1efa96893ee583c91eefc069e6a0008380928e7697d715ba"
    sha256 cellar: :any,                 arm64_ventura: "c72861921c9a3d836f81f7eb678bdf0c2e77a086734981ee14a3d53e8c41ba17"
    sha256 cellar: :any,                 sonoma:        "c46dce1d3dd20058a9a8fa66f962e7854cb11e96ebe5ddec38cbf8da6ae695d2"
    sha256 cellar: :any,                 ventura:       "bd4cf1f84d8871d1e9ab1aaa95032852d4d0e6e7abccd2f6c6c54b68e4f4c876"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "813f46eafb096fa5742e69f32953f9ca658e696930dadb24347cb560dd9d3c11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8abf7f8788b954ce7158be70e901dbd050139aa6f76975108dc2b8a2e6877a81"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "fluid-synth"
  depends_on "libpng"
  depends_on "libsamplerate"
  depends_on "sdl2"
  depends_on "sdl2_mixer"
  depends_on "sdl2_net"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install", "execgamesdir=#{bin}"
    rm_r(share/"applications")
    rm_r(share/"icons")
  end

  def caveats
    <<~EOS
      Note that this formula only installs a Doom game engine, and no
      actual levels. The original Doom levels are still under copyright,
      so you can copy them over and play them if you already own them.
      Otherwise, there are tons of free levels available online.
      Try starting here:
        #{homepage}
    EOS
  end

  test do
    testdata = <<~EOS
      Invalid IWAD file
    EOS
    (testpath/"test_invalid.wad").write testdata

    expected_output = "Wad file test_invalid.wad doesn't have IWAD or PWAD id"
    assert_match expected_output, shell_output("#{bin}/chocolate-doom -nogui -iwad test_invalid.wad 2>&1", 255)
  end
end
