class ErofsUtils < Formula
  desc "Utilities for Enhanced Read-Only File System"
  homepage "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git"
  url "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/snapshot/erofs-utils-1.8.10.tar.gz"
  sha256 "05eb4edebe11decce6ecb34e98d2f80c8cd283c2f2967d8ba7efd58418570514"
  license "GPL-2.0-or-later"
  head "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git", branch: "master"

  livecheck do
    url "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/refs/"
    regex(/href=.*?erofs-utils[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "74421b46b5e4d74ea7db26e59e68795df9ad8bf16ebdd01e592d387d30886062"
    sha256 cellar: :any,                 arm64_sequoia: "b174f3b652f72de1830fbc87f77bfcd20d5e4e8332b234d6d82cac2504ace237"
    sha256 cellar: :any,                 arm64_sonoma:  "1b7334a9d05b74b253ccbf19f14b5239d14cb1f47f5a38fa1c035c8a2ed61cb6"
    sha256 cellar: :any,                 arm64_ventura: "b059764774718929bb84e69fc0dcac51bf0d2819cdd75e6016df77fda2695c21"
    sha256 cellar: :any,                 sonoma:        "c8aa11405cbb3a8d3a21e6662b65672a7785963c168f27fe2b31d07e0f59b739"
    sha256 cellar: :any,                 ventura:       "24cf420f807e846c42c7b0a1edf81d7b218dbca608f991128b01f13e0400aa59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb03b56ff7a012df2fe260656e3cc9d7076547cd21283fa1f9fe4b9e400983fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7eb92c707a9e789b23311707b07bab6a09097d07eb4d33caab2acd53afba59ec"
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
