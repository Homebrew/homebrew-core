class ErofsUtils < Formula
  desc "Utilities for Enhanced Read-Only File System"
  homepage "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git"
  url "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/snapshot/erofs-utils-1.8.9.tar.gz"
  sha256 "145a6f7fe4941814d30099c3568448d37c819ccd030fc5bfbcaab21134e6176e"
  license "GPL-2.0-or-later"
  head "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git", branch: "master"

  livecheck do
    url "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/refs/"
    regex(/href=.*?erofs-utils[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bf88ce7570102718eacf17d8d82477b8dafa0b06f20ae25aae0f009069cce458"
    sha256 cellar: :any,                 arm64_sonoma:  "5bc927550cead7e3c4e39745bedee218275db4148e369da38bb96e3c7ae35bc7"
    sha256 cellar: :any,                 arm64_ventura: "ee95d6d32629cd8f57ac2f565f3a0274fbf9a6d5d084c1e18dc87544b0982a40"
    sha256 cellar: :any,                 sonoma:        "e8e03e1d15b3f7269f8d82a06b119232719bed44ac40c3aea8b0dd20f5080877"
    sha256 cellar: :any,                 ventura:       "fcbbeef2973d449073460d992916f4575b59ffd622d47f13e0c85aed38570264"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebb9665ce6e1b6565ee1fa7a3f19a81454b9a98c29142fe3e99aa9ce425e9a7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1491f9fed511163cfb6ae5d2fb8c40164e35aded9b9c1d1bb55429cd7cca0910"
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
