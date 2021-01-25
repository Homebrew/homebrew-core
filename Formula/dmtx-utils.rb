class DmtxUtils < Formula
  desc "Read and write data matrix barcodes"
  homepage "https://github.com/dmtx/dmtx-utils"
  url "https://github.com/dmtx/dmtx-utils/archive/v0.7.6.tar.gz"
  sha256 "0d396ec14f32a8cf9e08369a4122a16aa2e5fa1675e02218f16f1ab777ea2a28"
  license "LGPL-2.1"
  revision 2

  bottle do
    cellar :any
    sha256 "97e1235bf73de14de83c96baa9ea3ff32b72c27f49d776af3d672fd5bd779d3b" => :big_sur
    sha256 "4f026d11495fe7b279007f6691f859352be3ca9c87d97353fc5f51729e6ea93d" => :arm64_big_sur
    sha256 "0985c4c4a239de3a85eb2201f15c8ae12dbb49ccc9036f93f728e13d0d46705b" => :catalina
    sha256 "7f2702b52b6e627607593542f0276a092b08de852200fa8fbc051ca76a00a3b5" => :mojave
    sha256 "0de24aad51177bb26b8e33c7e459919e158fad2357436314410ccefc60e18024" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "imagemagick"
  depends_on "libdmtx"
  depends_on "libtool"

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
