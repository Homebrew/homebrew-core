class Mjpegtools < Formula
  desc "Record and playback videos and perform simple edits"
  homepage "https://mjpeg.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mjpeg/mjpegtools/2.2.1/mjpegtools-2.2.1.tar.gz"
  sha256 "b180536d7d9960b05e0023a197b00dcb100929a49aab71d19d55f4a1b210f49a"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "b837a632e4043b64a8eb3a6cc1fc8fd27358c6d6a79e0728ed8364b839afcfd1"
    sha256 cellar: :any, arm64_tahoe:       "2abecdb0e554d4f388fff7348b628a47fb7895743cc8868541724ce4d85ae88d"
    sha256 cellar: :any, arm64_sequoia:     "c47b25ab68df1da19d4fc125415cec33f6c19dfdb61e7df83a67f34571fb1540"
    sha256 cellar: :any, arm64_linux:       "21c6aa501bd95efff455177f4f95651efc07094c77ea1bc0bf520996c2d51f44"
    sha256 cellar: :any, x86_64_linux:      "3d7777e45ce7cdf38caecb5f96e0812d6a9247c378a81e88f7c2efba78de2b80"
  end

  depends_on "pkgconf" => :build
  depends_on "jpeg-turbo"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    file "Patches/libtool/configure-big_sur.diff"
  end

  # Fixes: error: 'class Region2D<INDEX, SIZE>' has no member named 'DoesContainPoint'
  patch do
    url "https://sourceforge.net/p/mjpeg/patches/63/attachment/gcc-15.patch"
    sha256 "0bdaf8f7e584183d770925563ce065c8773f1ea7f5327ed2d62be19c6187cd8c"
    type :unofficial
    resolves "https://sourceforge.net/p/mjpeg/patches/63/"
  end

  deny_network_access!

  def install
    system "./configure", "--enable-simd-accel", *std_configure_args
    system "make", "install"
  end

  test do
    system "#{bin}/y4mcolorbars -v 0 -n 5 -W 64 -H 48 -S 420jpeg > bars.y4m"
    assert_match "YUV4MPEG2 W64 H48 F30000:1001 Ip A10:11 C420jpeg", (testpath/"bars.y4m").read(50)

    # Encode to MJPEG AVI and inspect / decode it again
    system "#{bin}/yuv2lav -v 0 -f a -o bars.avi < bars.y4m"
    info = shell_output("#{bin}/lavinfo bars.avi")
    assert_match "video_frames=5", info
    assert_match "video_width=64", info
    assert_match "video_height=48", info
    system "#{bin}/lav2yuv bars.avi > decoded.y4m"
    assert_equal "YUV4MPEG2 W64 H48 ", (testpath/"decoded.y4m").binread(18)
    assert_equal 5, (testpath/"decoded.y4m").binread.scan("FRAME\n").size

    # Encode to MPEG-1 video and check for the sequence header start code
    system "#{bin}/mpeg2enc -v 0 -f 0 -a 2 -o bars.m1v < bars.y4m"
    assert_equal "\x00\x00\x01\xB3".b, (testpath/"bars.m1v").binread(4)
  end
end
