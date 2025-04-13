class ErofsUtils < Formula
  desc "Utilities for Enhanced Read-Only File System"
  homepage "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git"
  url "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/snapshot/erofs-utils-1.8.6.tar.gz"
  sha256 "5b221dc3fd6d151425b30534ede46fb7a90dc233a8659cba0372796b0a066547"
  license "GPL-2.0-or-later"
  head "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git", branch: "master"

  livecheck do
    url "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/refs/"
    regex(/href=.*?erofs-utils[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c9817fc25ebcc38519098db7574e0f30c572fd4a3ab0733e0ad4d5325bfb4085"
    sha256 cellar: :any,                 arm64_sonoma:  "58ed7f18f8d0fa1dc59f89af00520fc3e517a507f0e2cab605d96d8619824c31"
    sha256 cellar: :any,                 arm64_ventura: "810b9e6176335824a78f3436dea554057e586d6b8d72247851b8b5755ccee45b"
    sha256 cellar: :any,                 sonoma:        "871cc1449daf3a852355704d7c08de6b5a7466874f240d14deb02bc7320acf5e"
    sha256 cellar: :any,                 ventura:       "0e9802c3e89f7970f560906280c11566769b4d0984486541b81d8d35019be12a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7968c98388aa3d63869cb2fcc7feefdbed9ce8701018a9d76fb4273a373af33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59b019bce96ed03fd50de50709be80b67166b57f9e27647abff573c97ca3e85e"
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
