class ErofsUtils < Formula
  desc "Utilities for Enhanced Read-Only File System"
  homepage "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git"
  url "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/snapshot/erofs-utils-1.6.tar.gz"
  sha256 "dbf1adaeff1bb8532b29a72c8a9e191938c9389946770dc763d3c59e6f320571"
  license "GPL-2.0-or-later"
  head "git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f69f0cd0038c11fb2aea11bcc4ea64efea05a9bd59dc7cd11a3cd0391643e9c1"
    sha256 cellar: :any,                 arm64_monterey: "33abf25e1673da43ea17e8ec42865ee17a6a14a6561c98a8082da0c7dc20ab72"
    sha256 cellar: :any,                 arm64_big_sur:  "188dbabd138c3adaddbb98dfc7b7d8aee02f2a2df29fa0a922a92dc49989a205"
    sha256 cellar: :any,                 ventura:        "219bc7d4452196d2b7c16e25048d1c0094c5777a4a187fd4a54e1c216fb574f9"
    sha256 cellar: :any,                 monterey:       "a2e7466b73754bf949d77c3bf1498638cd00f08b008cab3e052849886cd3dc99"
    sha256 cellar: :any,                 big_sur:        "184bab00df67946bc8a2ce5b66fc6ada971d3548ca05d432f60f0db3c8b44607"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "147da6559e52fecb5054a9072821df9f76192903bf800eeccde257f8a45fca76"
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
