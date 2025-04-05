class ErofsUtils < Formula
  desc "Utilities for Enhanced Read-Only File System"
  homepage "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git"
  url "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/snapshot/erofs-utils-1.8.5.tar.gz"
  sha256 "cd8611270e9c86fe062f647103ca6ada9ed710e4430fdd5960d514777919200d"
  license "GPL-2.0-or-later"
  revision 1
  head "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git", branch: "master"

  livecheck do
    url "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/refs/"
    regex(/href=.*?erofs-utils[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6d3f3715d9fc1dba241b4aba600bcd8f35d3857652d3a0425cf8150b57f39116"
    sha256 cellar: :any,                 arm64_sonoma:  "428b9b8a4e10a2f3a25cce145872602accd7d9ddb618279cbc6c5316e2561c76"
    sha256 cellar: :any,                 arm64_ventura: "a38cd23885c906fbc1bdf875b6ac227ef9e637da96d57bb65b87a7cae4221ba9"
    sha256 cellar: :any,                 sonoma:        "21f4b75c09d245f3e2a060b0f7b2588085046ee739f26407e102ef146315669c"
    sha256 cellar: :any,                 ventura:       "fbfb91b675618dfbf828b6ded7fa7a7d695c1420fcceb6ef5a24bfe250be8339"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ecb6ec0863b3a1f3d90db08c699a04a2fcf67c736fb176eae91d6c6d6ae45d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3379c9f03b066f57bc8c115fd7eeb5639a0811340a91227ced350e403a19c5a"
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
