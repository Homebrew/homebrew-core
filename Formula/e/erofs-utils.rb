class ErofsUtils < Formula
  desc "Utilities for Enhanced Read-Only File System"
  homepage "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git"
  url "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/snapshot/erofs-utils-1.8.1.tar.gz"
  sha256 "5dbf7b492f7682462b97a77121d43ca7609cd90e65f8c96931aefc820a6f0da3"
  license "GPL-2.0-or-later"
  head "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f0ffa1195c8c309d367c98c0c97ecfc5bf55bd4d55cfde8397cff07a29114242"
    sha256 cellar: :any,                 arm64_ventura:  "c9e4842ed8febb197edb0f3b84736b1cbb7572b833aff557a11fbb8fe5d19f80"
    sha256 cellar: :any,                 arm64_monterey: "9e1f64a8d4aa8393b1a76a9c6906996827528c51d09647ce2cfe082c7702f9e2"
    sha256 cellar: :any,                 sonoma:         "d849d952892f18f6105a7ce0319ccc21fb2fb07038f625d43d5a320615601476"
    sha256 cellar: :any,                 ventura:        "ad98edc8e3bcb73ff61567a9d5b8caeb3809e296f76021448cf5c33e62c77642"
    sha256 cellar: :any,                 monterey:       "bf9e5c2fe1194e8f3127334dc4c1c3bb3d6685322ae7605e8559576e0ff3b496"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b48446069899aa6ba26d6a5684e113bed0e5be0dc39bf5bb8512d280d487d9b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "lz4"
  depends_on "util-linux" # for libuuid
  depends_on "xz"

  uses_from_macos "zlib"

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
