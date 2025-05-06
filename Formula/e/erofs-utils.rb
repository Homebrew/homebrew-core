class ErofsUtils < Formula
  desc "Utilities for Enhanced Read-Only File System"
  homepage "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git"
  url "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/snapshot/erofs-utils-1.8.6.tar.gz"
  sha256 "5b221dc3fd6d151425b30534ede46fb7a90dc233a8659cba0372796b0a066547"
  license "GPL-2.0-or-later"
  revision 1
  head "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git", branch: "master"

  livecheck do
    url "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/refs/"
    regex(/href=.*?erofs-utils[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "03e075a445897ce1acaf6ddc02e62ddb705972ea6f26a31e2e5b991a841aeb73"
    sha256 cellar: :any,                 arm64_sonoma:  "f90df104dd53380797ec856b06802d9da4788212649f6ce4c4a6763ebc309651"
    sha256 cellar: :any,                 arm64_ventura: "dcc67b92eea9b1f17038baed4c2413567a541951c9210ac988496833be0276fd"
    sha256 cellar: :any,                 sonoma:        "4c0a889e8005956e1501f974286d9ab5e060481e78069bd5fd681b3d885ae17f"
    sha256 cellar: :any,                 ventura:       "19c47bf9e4d9e2e9309232f9b72f65454c7a92a91de0993a26c3b9b6c3d833ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "431c2a838f37fcef7bd49655e72aa754c7ade8184e138c727ae5ca60d1384528"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26ff2d6669966a7967651ca4b59acac8316abae5042a7fbdf48eaeeff8d0045b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "lz4"
  depends_on "xz"

  uses_from_macos "zlib"

  on_linux do
    depends_on "libfuse"
    depends_on "util-linux" # for libuuid
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
