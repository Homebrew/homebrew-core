class ErofsUtils < Formula
  desc "Utilities for Enhanced Read-Only File System"
  homepage "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git"
  url "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/snapshot/erofs-utils-1.7.tar.gz"
  sha256 "b6eb529bb423eb2dd779c9da9c2632855488b4b91e23553a31ce23f11c9cce2c"
  license "GPL-2.0-or-later"
  head "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "69ce19442fa23ec4a0b782681e5fea5f321373a4a87d1c5a8b371cfabce89f0b"
    sha256 cellar: :any,                 arm64_monterey: "b100222d442267ca2e81d5d09512277a7df5b9bd4f7985853f911e8db4026921"
    sha256 cellar: :any,                 arm64_big_sur:  "40d063fb584e5265cf6fcaded49114064a4a063de3fa036b1be36e6be2195e9b"
    sha256 cellar: :any,                 ventura:        "58057b4ea764c9c376d3cc12f1571f8ff10d9f66b873aa8d4559d818b6a147e1"
    sha256 cellar: :any,                 monterey:       "ed0728db74796c3b7e7895e194f596743c24c5a6f91419c7eefd858c79459766"
    sha256 cellar: :any,                 big_sur:        "70335c6c61a657148ef55844f804a90982468c11b82c0d056222fbb42eaed35b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98419dadbc3fd08a2d1c2b5f82fbeb32be2c33a0e285685d208e303feb7e678b"
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
