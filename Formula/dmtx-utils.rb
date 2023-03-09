class DmtxUtils < Formula
  desc "Read and write data matrix barcodes"
  homepage "https://github.com/dmtx/dmtx-utils"
  url "https://github.com/dmtx/dmtx-utils/archive/v0.7.6.tar.gz"
  sha256 "0d396ec14f32a8cf9e08369a4122a16aa2e5fa1675e02218f16f1ab777ea2a28"
  license "LGPL-2.1"
  revision 6

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "65d04597069d638a468b5d3a4efb2f692d2db3252f6224498ae74355f10dde49"
    sha256 cellar: :any,                 arm64_monterey: "37e220d882d243c0eadb50f15548d7d21173086c86b43a113b5653e874992167"
    sha256 cellar: :any,                 arm64_big_sur:  "44f0cbd9a5de8cbc33a3e1ec377388fd482e14e56c6eb6d9655ec3ea6c0c6221"
    sha256 cellar: :any,                 ventura:        "a59cdc1655b0d2c2f01064a7df57f633712d1b0f7c6e526a55a8f88a36e570e0"
    sha256 cellar: :any,                 monterey:       "410a0dada9e7952b29db3bc96664990056099b764430e5d989f9a6450b99cf21"
    sha256 cellar: :any,                 big_sur:        "aa71909f139e1f2a4fd4b19e169802c209de4e6a878d787100d9b82191f4e0a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66a12e61bcf4893b8ad93934ad2939df35a8bf3eda7264b92acb6e38d060db49"
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
