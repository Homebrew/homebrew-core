class DmtxUtils < Formula
  desc "Read and write data matrix barcodes"
  homepage "https://github.com/dmtx/dmtx-utils"
  url "https://github.com/dmtx/dmtx-utils/archive/refs/tags/v0.7.6.tar.gz"
  sha256 "0d396ec14f32a8cf9e08369a4122a16aa2e5fa1675e02218f16f1ab777ea2a28"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 10

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a9bbe445f01e034c3ce5118fc6b337ee25ee255486a561c2efca07bcdc7451e6"
    sha256 cellar: :any, arm64_sequoia: "6555934ddec5067a3cebe730f2f3203673070196d857a84f8c21bff336d1d2c9"
    sha256 cellar: :any, arm64_sonoma:  "223fe6ac211eee3b64ff751a0a2949290eb63ca9e9c7d2692dae0ad5aec4216a"
    sha256 cellar: :any, sonoma:        "e6299701b5b82b6dccaa37959a2aab32a959ff6e89dc6612f29ebb7406df48b0"
    sha256 cellar: :any, arm64_linux:   "d5e376af9a846cb08a1e259ca7893abcbddb85f61a56664fddfb81002171cc41"
    sha256 cellar: :any, x86_64_linux:  "2dfad16186f55c88d6ffb5bd335c4756f8a657556c47ea728bc8990c0c5374bf"
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
  patch do
    url "https://github.com/dmtx/dmtx-utils/commit/f7b97efc3bd6fc2e4403803f46514ae28318743b.patch?full_index=1"
    sha256 "e9a44b85bce58ed9c4af90f123c2317a9f4a4b9dade114a9014211e22bcc5c4d"
    type :backport
    resolves "https://github.com/dmtx/dmtx-utils/pull/16"
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
