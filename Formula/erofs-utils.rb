class ErofsUtils < Formula
  desc "Utilities for Enhanced Read-Only File System"
  homepage "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git"
  url "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/snapshot/erofs-utils-1.5.tar.gz"
  sha256 "2310fa4377b566bf943e8eef992db3990f759528d5973e700efe3e4cb115ec23"
  license "GPL-2.0-or-later"
  head "git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "575602c8b72d4b7474f08862c92655ee551935ca742508f833e22b88077fde08"
    sha256 cellar: :any,                 arm64_big_sur:  "6b09c4568245e7ba0442e00bc87342ec5030acb9393c0dccf886a72bdcfb04fe"
    sha256 cellar: :any,                 monterey:       "df01bcb6e5b5faa32155211916825784564fadce9f610183ef3efd0555dba8b6"
    sha256 cellar: :any,                 big_sur:        "4bddb7c29191fee61c9c94204d7876096fdcb85ea76d8003b3785ad90ac2bd01"
    sha256 cellar: :any,                 catalina:       "dddfb64d62d09af5c46bb53dd99f35a8208259ca17d7681e6a6fe608b866bb09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "650c01bb5fdd4b389c59ac51b3788bdd8cf469145082f007ec94cfda33794045"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "lz4"
  depends_on "util-linux" # for libuuid

  on_linux do
    depends_on "libfuse@2"
  end

  def install
    system "./autogen.sh"
    args = std_configure_args + %w[
      --disable-silent-rules
      --enable-lz4
      --disable-lzma
      --without-selinux
    ]

    # Enable erofsfuse only on Linux for now
    args << if OS.linux?
      "--enable-fuse"
    else
      "--disable-fuse"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"in/test1").write "G'day!"
    (testpath/"in/test2").write "Bonjour!"
    (testpath/"in/test3").write "Moien!"

    # Test mkfs.erofs can make a valid erofsimg.
    #   (Also tests that `lz4` support is properly linked.)
    system "#{bin}/mkfs.erofs", "--quiet", "-zlz4", "test.lz4.erofs", "in"
    assert_predicate testpath/"test.lz4.erofs", :exist?

    # Unfortunately, fsck.erofs doesn't support extraction for now, and
    # erofsfuse doesn't officially work on MacOS
  end
end
