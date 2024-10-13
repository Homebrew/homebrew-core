class DmtxUtils < Formula
  desc "Read and write data matrix barcodes"
  homepage "https://github.com/dmtx/dmtx-utils"
  url "https://github.com/dmtx/dmtx-utils/archive/refs/tags/v0.7.6.tar.gz"
  sha256 "0d396ec14f32a8cf9e08369a4122a16aa2e5fa1675e02218f16f1ab777ea2a28"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 6

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "4132090992b9abc13dc2f70a34d745240e4d82fe9731f97e3329fb9d3e9627d9"
    sha256 cellar: :any,                 arm64_sonoma:   "152c08bbdef851937b9b330243318d4d49a3d7563c9e85b703753d44b2e005b4"
    sha256 cellar: :any,                 arm64_ventura:  "c147ab73dac9c03562cf06d561a923ba70e30ecb4607d755622d0156805a7892"
    sha256 cellar: :any,                 arm64_monterey: "81be259b08bd67f4dab389bb326b4adbdd01cd201d5b98c77f4cc72e0f5c669a"
    sha256 cellar: :any,                 arm64_big_sur:  "f7e90d8cd99bbedb06dffa5338d64e65307fcb4c98095d897a91466a8da86322"
    sha256 cellar: :any,                 sonoma:         "eb533e070969a723b9aa747dab30b457e29c647db29a6872ab98f2108f15197d"
    sha256 cellar: :any,                 ventura:        "161997f60768bb9798550757f0a01e2e27434934d9ec8a2b47153a52abe10cd7"
    sha256 cellar: :any,                 monterey:       "7a754c6517fc4a35d07c17a34b3bf98d62d85fa6015f11ecd38d92db4e1c0372"
    sha256 cellar: :any,                 big_sur:        "fa4722a33d220d1f8cd8740c4b6d938e92f8d9b76ab555762cc8c84c72084573"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc7f066604465fcaf850671368291a758eec7fa261d6bbdbde892b798fd0daa1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build

  depends_on "imagemagick"
  depends_on "libdmtx"
  depends_on "libtool"

  on_macos do
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "gettext"
    depends_on "glib"
    depends_on "liblqr"
    depends_on "libomp"
    depends_on "little-cms2"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    resource "homebrew-test_image12" do
      url "https://raw.githubusercontent.com/dmtx/libdmtx/ca9313f/test/rotate_test/images/test_image12.png"
      sha256 "683777f43ce2747c8a6c7a3d294f64bdbfee600d719aac60a18fcb36f7fc7242"
    end

    testpath.install resource("homebrew-test_image12")
    image = File.read("test_image12.png")
    assert_equal "9411300724000003", pipe_output("#{bin}/dmtxread", image, 0)
    system "/bin/dd", "if=/dev/random", "of=in.bin", "bs=512", "count=3"
    dmtxwrite_output = pipe_output("#{bin}/dmtxwrite", File.read("in.bin"), 0)
    dmtxread_output = pipe_output("#{bin}/dmtxread", dmtxwrite_output, 0)
    (testpath/"out.bin").atomic_write dmtxread_output
    assert_equal (testpath/"in.bin").sha256, (testpath/"out.bin").sha256
  end
end
