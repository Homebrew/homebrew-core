class ErofsUtils < Formula
  desc "Utilities for Enhanced Read-Only File System"
  homepage "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git"
  url "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/snapshot/erofs-utils-1.9.1.tar.gz"
  sha256 "a9ef5ab67c4b8d2d3e9ed71f39cd008bda653142a720d8a395a36f1110d0c432"
  license "GPL-2.0-or-later"
  head "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git", branch: "master"

  livecheck do
    url "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/refs/"
    regex(/href=.*?erofs-utils[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fcd98111d3eaf796ebb28e1714fca383c2b750c75aa7a692991d2b1abaeec321"
    sha256 cellar: :any,                 arm64_sequoia: "fc05f424e0cac372e60490b710d30184ee92faaee899de8759c4f2f3b6e12ca9"
    sha256 cellar: :any,                 arm64_sonoma:  "d35a4cdbd72dd9b04bf33ec14f2d786da070606eca70c93a9c3040a507a09c46"
    sha256 cellar: :any,                 sonoma:        "781c2d8a935ba8e8c7b8a5f2721d3a1cfbe695927c1afe67da0392d462f19229"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec5a0c1d3922c42c26d84c5b3f2cfe8ceaa0e18db0256da169fa8722a1fce6d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7635fad4505da693bfa9b47be3669fb7bffcbd70425e04c099b48dfb868d5d2c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "lz4"
  depends_on "xz"

  on_linux do
    depends_on "libfuse"
    depends_on "util-linux" # for libuuid
    depends_on "zlib-ng-compat"
  end

  def install
    # Link to liblzma from brew rather than system
    ENV.append "LDFLAGS", "-L#{Formula["xz"].opt_lib}"

    args = %w[
      --disable-silent-rules
      --enable-lz4
      --enable-lzma
      --without-selinux
    ]

    # Enable erofsfuse only on Linux
    args << if OS.linux?
      "--enable-fuse"
    else
      "--disable-fuse"
    end

    system "./autogen.sh"
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"in/test1").write "G'day!"
    (testpath/"in/test2").write "Bonjour!"
    (testpath/"in/test3").write "Moien!"

    # Test mkfs.erofs can make a valid erofsimg.
    #   (Also tests that `lz4` support is properly linked.)
    system bin/"mkfs.erofs", "--quiet", "-zlz4", "test.lz4.erofs", "in"
    assert_path_exists testpath/"test.lz4.erofs"

    # Test mkfs.erofs can make a valid erofsimg.
    #   (Also tests that `lzma` support is properly linked.)
    system bin/"mkfs.erofs", "--quiet", "-zlzma", "test.lzma.erofs", "in"
    assert_path_exists testpath/"test.lzma.erofs"

    # Unfortunately, fsck.erofs doesn't support extraction for now, and
    # erofsfuse doesn't officially work on MacOS
  end
end
