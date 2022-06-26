class DmtxUtils < Formula
  desc "Read and write data matrix barcodes"
  homepage "https://github.com/dmtx/dmtx-utils"
  url "https://github.com/dmtx/dmtx-utils/archive/v0.7.6.tar.gz"
  sha256 "0d396ec14f32a8cf9e08369a4122a16aa2e5fa1675e02218f16f1ab777ea2a28"
  license "LGPL-2.1"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c2fb338b5c1accf8ae28a76b962098dfb6fcbccb7835028de99f92de60530537"
    sha256 cellar: :any,                 arm64_big_sur:  "9db11b5cb18a18e7e02d369353730e2c6e574e2154db95e60fd9a82983d8be83"
    sha256 cellar: :any,                 monterey:       "2cfbd07ad1760cbe66991740574f92a045c59b030699fddb8312fab09d52c7f6"
    sha256 cellar: :any,                 big_sur:        "0f5cbe20fda6fcc8db3bf57039ced929283a31b666f38da8a64ba5c6c19d76cd"
    sha256 cellar: :any,                 catalina:       "20b46ae2ba790f10191d8f53c8ce3095222d1b814db72990e7fc48a501fabba9"
    sha256 cellar: :any,                 mojave:         "810dec06d01994da047123c4169d7398efacd4060adc639fdbcb845f3c6e2606"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "189265385499967b8f5e1c6eb8659f54b388ac013947a211f08607a0aaf95925"
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
