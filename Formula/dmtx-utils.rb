class DmtxUtils < Formula
  desc "Read and write data matrix barcodes"
  homepage "https://github.com/dmtx/dmtx-utils"
  url "https://github.com/dmtx/dmtx-utils/archive/v0.7.6.tar.gz"
  sha256 "0d396ec14f32a8cf9e08369a4122a16aa2e5fa1675e02218f16f1ab777ea2a28"
  license "LGPL-2.1"
  revision 4

  bottle do
    sha256 cellar: :any, arm64_big_sur: "4c76806a80dcc2dead871d4a765bbdc37dc0ea00846fb0b3d41ad5f97009b1fe"
    sha256 cellar: :any, big_sur:       "4116701fe2a23629a0b5c2b928995eb1c1fe7b6d7ca99edc40e8cd04bbcbb4d0"
    sha256 cellar: :any, catalina:      "69af0e060f133fd09e64cd81096ed8c920471882bce587ba8f8e061a23fbe786"
    sha256 cellar: :any, mojave:        "77379df5387a1fc39f908644865e451a938272853f54f8640b6b379fa1d872d3"
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
