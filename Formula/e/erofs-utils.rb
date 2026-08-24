class ErofsUtils < Formula
  desc "Utilities for Enhanced Read-Only File System"
  homepage "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git"
  url "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/snapshot/erofs-utils-1.9.4.tar.gz"
  sha256 "7d135aa2550326a5acf20f53c518aea5a8900015ce50700044e40f818c31dd80"
  license "GPL-2.0-or-later"
  head "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git", branch: "master"

  livecheck do
    url "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/refs/"
    regex(/href=.*?erofs-utils[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2e9e4f282caf94e14e3fb09f4ddcf9a7efd637bb60ff777b0ce1c675769e45ee"
    sha256 cellar: :any, arm64_sequoia: "87e9ef8002a87275c018cffd127f7eb11de4553cc53edd7b20b81a8e407580c4"
    sha256 cellar: :any, arm64_sonoma:  "90b65cd37db371ea91983ed8ca90b04d4325408368bfded618375f401ef5f3d0"
    sha256 cellar: :any, sonoma:        "477efe0142e48843a22a67f19434952502f032e5ed9cf0a4a078249a10a423fc"
    sha256 cellar: :any, arm64_linux:   "41c13dbf80ce34a685bca834c6e54b0547ca7cf6b84bd1f18b5f8c866b61052c"
    sha256 cellar: :any, x86_64_linux:  "8c0c99d07dc9b93cf8df32716ee1b50cb51acf70478e463d0019b6d75d493991"
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
    ENV.append "LDFLAGS", "-L#{formula_opt_lib("xz")}"

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
