class CrispyDoom < Formula
  desc "Limit-removing enhanced-resolution Doom source port based on Chocolate Doom"
  homepage "https://github.com/fabiangreffrath/crispy-doom"
  url "https://github.com/fabiangreffrath/crispy-doom/archive/crispy-doom-5.10.1.tar.gz"
  sha256 "ba2f1ff7f85141cbd7780604f473566018432fae2bbcb86652fe2072aa0ea5e2"
  license "GPL-2.0-only"

  head "https://github.com/fabiangreffrath/crispy-doom"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "5e88cf832e124281f4eda3126ea53ae012fd8a9680387eede0ec342c15633f82"
    sha256 cellar: :any, big_sur:       "6ba5a4d2d248da3374409e2cb94dbce8391518a1ec54ac0f4267139a194f3812"
    sha256 cellar: :any, catalina:      "5dfb49f1137d3776c4476e1e40ee5d218a70e4b379f2d768d5f2120f2ac71542"
    sha256 cellar: :any, mojave:        "0a08c94e89eeeccb0e7a8a6e1f4968aa1f0bcfcbd9020fed9342727cc2954871"
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
