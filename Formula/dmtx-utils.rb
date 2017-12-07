class DmtxUtils < Formula
  desc "Read and write data matrix barcodes"
  homepage "https://github.com/dmtx/dmtx-utils"
  url "https://github.com/dmtx/dmtx-utils/archive/v0.7.5.tar.gz"
  sha256 "6fa365cd321609db40800f6b34a2387c0ac56ef4643f6101ac83cb762f5ce9ef"
  revision 3

  bottle do
    cellar :any
    sha256 "2373f702d73deef207316466fa1ea724c33db397b1b6fa18fca6fc333b619bb1" => :high_sierra
    sha256 "1ddf7aa4238bc24df4c249041e3cd964987ae6c773d2b3ac6c12b95b9784631d" => :sierra
    sha256 "8ce569eb1a9af3a0ea25936d9ee9947bd830301615db43ee04cbd5c22863c47e" => :el_capitan
    sha256 "d045cc55b0bd09b36dd81ae3168dd8e996743c0e4dd2578649658615b9daf48c" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "imagemagick"
  depends_on "libdmtx"
  depends_on "libtool" => :run

  resource "test_image12" do
    url "https://raw.githubusercontent.com/dmtx/libdmtx/ca9313f/test/rotate_test/images/test_image12.png"
    sha256 "683777f43ce2747c8a6c7a3d294f64bdbfee600d719aac60a18fcb36f7fc7242"
  end

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    testpath.install resource("test_image12")
    image = File.read("test_image12.png")
    assert_equal "9411300724000003", pipe_output("#{bin}/dmtxread", image, 0)
    system "/bin/dd", "if=/dev/random", "of=in.bin", "bs=512", "count=3"
    dmtxwrite_output = pipe_output("#{bin}/dmtxwrite", File.read("in.bin"), 0)
    dmtxread_output = pipe_output("#{bin}/dmtxread", dmtxwrite_output, 0)
    (testpath/"out.bin").atomic_write dmtxread_output
    assert_equal (testpath/"in.bin").sha256, (testpath/"out.bin").sha256
  end
end
