class ErofsUtils < Formula
  desc "Utilities for Enhanced Read-Only File System"
  homepage "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git"
  url "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/snapshot/erofs-utils-1.7.tar.gz"
  sha256 "b6eb529bb423eb2dd779c9da9c2632855488b4b91e23553a31ce23f11c9cce2c"
  license "GPL-2.0-or-later"
  head "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "705616314ec502b4b84430dd81aa18fed63d7ef0c40faa8444f219669f1dc895"
    sha256 cellar: :any,                 arm64_ventura:  "9e8884f35e0510c5c6a3ecb974ca242b9c480587a0428ed205b3f40c00ee1795"
    sha256 cellar: :any,                 arm64_monterey: "9477dc6bf3ded0275c9949196adb9badb49b641314cc7420d7e7777034c7fdb0"
    sha256 cellar: :any,                 sonoma:         "b1d915256b7c3b072db4f9a0d610b412acbb8abff5ce9869b34c4bb33e17cbdb"
    sha256 cellar: :any,                 ventura:        "e04908af1aa813b76aeb56ebd7deb33ed5f4a1cce09f6da55eab600458f4502c"
    sha256 cellar: :any,                 monterey:       "a9aa931db81006e5e1c2548b037d1222f0d41aad16cbd12e7564918a60182a0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "076aa10a0680a395df2bd215f7a4ba917ebd6a82b51ef281df4215cc3eaf4dd7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "lz4"
  depends_on "util-linux" # for libuuid
  depends_on "xz"

  on_linux do
    depends_on "libfuse@2"
  end

  def install
    system "./autogen.sh"
    args = std_configure_args + %w[
      --disable-silent-rules
      --enable-lz4
      --enable-lzma
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

    # Test mkfs.erofs can make a valid erofsimg.
    #   (Also tests that `lzma` support is properly linked.)
    system "#{bin}/mkfs.erofs", "--quiet", "-zlzma", "test.lzma.erofs", "in"
    assert_predicate testpath/"test.lzma.erofs", :exist?

    # Unfortunately, fsck.erofs doesn't support extraction for now, and
    # erofsfuse doesn't officially work on MacOS
  end
end
