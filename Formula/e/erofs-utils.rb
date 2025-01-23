class ErofsUtils < Formula
  desc "Utilities for Enhanced Read-Only File System"
  homepage "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git"
  url "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/snapshot/erofs-utils-1.8.4.tar.gz"
  sha256 "791587aa074bb9f9fa218c762cc1f60b015e2f51bcb2ce91f682f043856ab494"
  license "GPL-2.0-or-later"
  head "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git", branch: "master"

  livecheck do
    url "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/refs/"
    regex(/href=.*?erofs-utils[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4bca7493668272f6e55904400a266bf694ba8f432fa429938046c4d7e95ee78a"
    sha256 cellar: :any,                 arm64_sonoma:  "0d82f93be7648579d38311a51b82c7cae29254511efe49137ee5d7aa3f82413c"
    sha256 cellar: :any,                 arm64_ventura: "66402b6d10b5ad00fc4a9e78cefb93235f86f0f26ca71d7488405364ccec0a20"
    sha256 cellar: :any,                 sonoma:        "b378faf800cd2871c9ba8efc4dbf64f764493c633ee8b27dd5aa7c2a7007e773"
    sha256 cellar: :any,                 ventura:       "172c087a7f1e02c833f86c40265d69fab1ddded31cc79d71868a2cfb9ed42346"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "145fdff69802d0a60964a55064973b684638313f9c9ff915d04012cb53114879"
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
