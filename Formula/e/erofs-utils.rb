class ErofsUtils < Formula
  desc "Utilities for Enhanced Read-Only File System"
  homepage "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git"
  url "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/snapshot/erofs-utils-1.8.2.tar.gz"
  sha256 "64b6ff7e899f62480283cee63787f37f0f9c4be7a6bc7a23d734aaa873a6cff4"
  license "GPL-2.0-or-later"
  head "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5035f77586cbf76d18023e795777e4432469ed3746affb79e8b4fa9b6126dd1f"
    sha256 cellar: :any,                 arm64_sonoma:  "568801efa832bc9bb43396d4c9b9633e9aa484e3dc56c10c2476451201688b28"
    sha256 cellar: :any,                 arm64_ventura: "d314c87ea1bb5cd2a2047395beaca24021e9e0d8dcaaab44f2ecdc0452de5933"
    sha256 cellar: :any,                 sonoma:        "ec728a19423c18a82de1b43c594b22ac3d699e443984a92d43b415a865800457"
    sha256 cellar: :any,                 ventura:       "29a2413f88d967810a0b0c73bc75d432a5704baeb9b33d7c2831687ea86988d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77e66fabf0edacf196349d1ee06eb0cb9423eda1b68ecc04216dae3c64a8337d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "lz4"
  depends_on "xz"

  uses_from_macos "zlib"

  on_linux do
    depends_on "libfuse"
    depends_on "util-linux" # for libuuid
  end

  def install
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
    assert_predicate testpath/"test.lz4.erofs", :exist?

    # Test mkfs.erofs can make a valid erofsimg.
    #   (Also tests that `lzma` support is properly linked.)
    system bin/"mkfs.erofs", "--quiet", "-zlzma", "test.lzma.erofs", "in"
    assert_predicate testpath/"test.lzma.erofs", :exist?

    # Unfortunately, fsck.erofs doesn't support extraction for now, and
    # erofsfuse doesn't officially work on MacOS
  end
end
