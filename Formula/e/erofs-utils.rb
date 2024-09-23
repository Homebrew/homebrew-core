class ErofsUtils < Formula
  desc "Utilities for Enhanced Read-Only File System"
  homepage "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git"
  url "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/snapshot/erofs-utils-1.8.1.tar.gz"
  sha256 "5dbf7b492f7682462b97a77121d43ca7609cd90e65f8c96931aefc820a6f0da3"
  license "GPL-2.0-or-later"
  head "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "d60adbc4354d07b6b7f829e96c66e2d65bf4a6f18c60565c9f5619e5ce86b3fe"
    sha256 cellar: :any,                 arm64_sonoma:  "5ddd2a802298bc22b0f7784f16890810e1af9f73dfd3ee58396f30102e2f227b"
    sha256 cellar: :any,                 arm64_ventura: "0472e2455690195f3681afab6fe4927f4403f23e5ae3f70fb2bf8abe574a57e9"
    sha256 cellar: :any,                 sonoma:        "84fe20c5fb319548a9217420714beb2156bc51238214bf73877d353947b95d98"
    sha256 cellar: :any,                 ventura:       "559f2bbedd19edbb82cb79a3d8640ddc2d18c29b809ec011b51b787af244468b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76937c27e27e87359203e58507c8a73eb6c7bbe8b877d3f1200efaef730e2a67"
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
