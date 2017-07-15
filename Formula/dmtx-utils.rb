class DmtxUtils < Formula
  desc "Read and write data matrix barcodes"
  homepage "https://github.com/dmtx/dmtx-utils"
  url "https://github.com/dmtx/dmtx-utils/archive/v0.7.5.tar.gz"
  sha256 "6fa365cd321609db40800f6b34a2387c0ac56ef4643f6101ac83cb762f5ce9ef"
  revision 1

  bottle do
    cellar :any
    sha256 "4075b892f492b9afe50ce2840158cd4b19d06bcf129749f2cd6e8e6c777634fb" => :sierra
    sha256 "f5cb2e45f79fe1456470c7085254b8af6e71eafe62c0b1601b21adaa62db8c8b" => :el_capitan
    sha256 "e6d4fda32908729a72b45c7103417d07b749cc4e7f798efa0b0ad70e9947536b" => :yosemite
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
