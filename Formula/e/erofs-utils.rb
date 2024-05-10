class ErofsUtils < Formula
  desc "Utilities for Enhanced Read-Only File System"
  homepage "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git"
  url "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/snapshot/erofs-utils-1.7.1.tar.gz"
  sha256 "196083d63e5e231fb5799e7ce86a944bbca564daabce3de9225a8aca9dcaff15"
  license "GPL-2.0-or-later"
  head "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "70afb5eb22ceebcb1a3d6acc23a764b1ae0244cb588dd36909dcfa0869608a7c"
    sha256 cellar: :any,                 arm64_ventura:  "cb3b3780c9df4ae7433ad11023283a6cbf7919addb024d694eab2b071ba3ab60"
    sha256 cellar: :any,                 arm64_monterey: "c0c7164d525c7d59f169213d674dd9739c98a589ba175870ae322aab22f0f589"
    sha256 cellar: :any,                 sonoma:         "280e7c817c99ac88a61b19ba31dd0d6dffdd8a2410eb0b7b7c793204f7af36b6"
    sha256 cellar: :any,                 ventura:        "1153316e3eaae7bb86506bf224c0988909c348c3e93449644a6c83892f4c07ec"
    sha256 cellar: :any,                 monterey:       "60e8cff8875bf6f1b567727234d465b4c77dd2ecac1656d2c2c7b116c34c8f24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6d3d584f064c10ebdcd206f01fc2148bd099e6fb3e3c506094ac0150399de6b"
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
