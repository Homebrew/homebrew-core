class ErofsUtils < Formula
  desc "Utilities for Enhanced Read-Only File System"
  homepage "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git"
  url "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/snapshot/erofs-utils-1.9.tar.gz"
  sha256 "d1bc84b5d60bcae121a7f57ea97d4155189087e178f8127f30846d9f537c9d73"
  license "GPL-2.0-or-later"
  head "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git", branch: "master"

  livecheck do
    url "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/refs/"
    regex(/href=.*?erofs-utils[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a916cd001c0fcaf18ab406be3bc5f36ab70071b713b68d3723894ec9ff90c463"
    sha256 cellar: :any,                 arm64_sequoia: "b47bd89556906816b6856d8f667bf4605e5468449a0e93231e350152a07f886b"
    sha256 cellar: :any,                 arm64_sonoma:  "ac12581ea1602490eb5c43ad1571233f369769e2ba31af5cd991ad584e049f03"
    sha256 cellar: :any,                 sonoma:        "71725266d4f0c47f0bfff4ac28522995233ae1741ff87a0e70e073c09a971aa2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1444389f8180d566d48b21c9250fa2670c4da35fb42be672515352672fb4db37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8d97e506dfa4fb9158f5e01c4054f4b50b1349b82bb03e087281896d0771dc4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "lz4"
  depends_on "xz"

  on_linux do
    depends_on "libfuse"
    depends_on "util-linux" # for libuuid
    depends_on "zlib-ng-compat"
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
