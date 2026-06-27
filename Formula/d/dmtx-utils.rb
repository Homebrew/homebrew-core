class DmtxUtils < Formula
  desc "Read and write data matrix barcodes"
  homepage "https://github.com/dmtx/dmtx-utils"
  url "https://github.com/dmtx/dmtx-utils/archive/refs/tags/v0.7.6.tar.gz"
  sha256 "0d396ec14f32a8cf9e08369a4122a16aa2e5fa1675e02218f16f1ab777ea2a28"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 9

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "07f22c3e96be28752be99d1a96fd530638d30b23dd468be55cb7f627b95988f8"
    sha256 cellar: :any, arm64_sequoia: "13d8bf91ff9a5ea62b2a6e762ccd074f3d3f6f0078b6d523690d753af73c1df8"
    sha256 cellar: :any, arm64_sonoma:  "17ad6a17f6adb6a85982ddcd6fc2a242f282eb30bd69432909a6304dc95b041b"
    sha256 cellar: :any, sonoma:        "d37d812fcdcee3f277c69e699107da20cf2368e26427bd4d7b4e02134922bda8"
    sha256 cellar: :any, arm64_linux:   "c29a21177f5fe932061b4b9ba394aae653a425a31f53423e02b8873e132e4324"
    sha256 cellar: :any, x86_64_linux:  "1e63847b01d0955861ac4713c6f15a97be3db73558e26fd5c14d88a139711f64"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build

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

  # Workaround buffer overflow
  # Upstream PR ref: https://github.com/dmtx/dmtx-utils/pull/16
  patch do
    url "https://github.com/dmtx/dmtx-utils/commit/f7b97efc3bd6fc2e4403803f46514ae28318743b.patch?full_index=1"
    sha256 "e9a44b85bce58ed9c4af90f123c2317a9f4a4b9dade114a9014211e22bcc5c4d"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
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
