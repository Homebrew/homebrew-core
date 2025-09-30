class DmtxUtils < Formula
  desc "Read and write data matrix barcodes"
  homepage "https://github.com/dmtx/dmtx-utils"
  url "https://github.com/dmtx/dmtx-utils/archive/refs/tags/v0.7.6.tar.gz"
  sha256 "0d396ec14f32a8cf9e08369a4122a16aa2e5fa1675e02218f16f1ab777ea2a28"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 8

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0d9a9f83919daef68ed7849bb0edeb5b0c99240b8854c4ea0b16aa95b061888a"
    sha256 cellar: :any,                 arm64_sequoia: "266e690457d4ad1f3844c37e52e3228121803ab16f5df2a8441ac8f0380a2b12"
    sha256 cellar: :any,                 arm64_sonoma:  "1ed0bf91ff69184917d25840c46c8b1a390e116b468dba2bfebcfca4688326f4"
    sha256 cellar: :any,                 arm64_ventura: "baccf696ad55b1eeda946e6e9e6f8085e6cee318bec01446bd260f774ec3ebd7"
    sha256 cellar: :any,                 sonoma:        "e4166dd09301ba1d1bf09ca625d395b145b5271b6e8c6938c6299b1b6773eac7"
    sha256 cellar: :any,                 ventura:       "57db09489948aa30d196602969ff17059e3668afd012b2bd21a56c1de4bf4e16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "003e60bbcf5bf79f791eb3e4e695d45648ae4cdf6d2b600972d900484bc5440c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86b15ef564fc867cfe335573ed209b3c96cb509859ac0507794433316d8246b4"
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
