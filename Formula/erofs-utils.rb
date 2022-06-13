class ErofsUtils < Formula
  desc "Utilities for Enhanced Read-Only File System"
  homepage "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git"
  url "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/snapshot/erofs-utils-1.5.tar.gz"
  sha256 "2310fa4377b566bf943e8eef992db3990f759528d5973e700efe3e4cb115ec23"
  license "GPL-2.0-or-later"
  head "git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f812b9f50ece8d4d7e81b37b57933185f9dc1bc9568b1c4de9f439e9a340e254"
    sha256 cellar: :any,                 arm64_big_sur:  "11e2d2ac010ffbfc3a0d76b3578c13f05c97ad9e5b00729f3d2133169cdc343e"
    sha256 cellar: :any,                 monterey:       "87db76ee25a677a010bb62467a32f187b6219e4146d44b25c36154fa09b5cc57"
    sha256 cellar: :any,                 big_sur:        "cddfe15f6b280c94e6963bd675d4d7a3e49683f92221e965af6622c8e9801b8a"
    sha256 cellar: :any,                 catalina:       "e438b1d7948e817de555cd9fb2717a883aa74bfe3b6ec26e8e4f6ac409cc155b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9eb89adcc6562bc174aded93a098155a4d73a52f149b974c4d690f7d1aa6706"
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
