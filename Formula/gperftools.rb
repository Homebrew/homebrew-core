class Gperftools < Formula
  desc "Multi-threaded malloc() and performance analysis tools"
  homepage "https://github.com/gperftools/gperftools"
  license "BSD-3-Clause"
  revision 1

  stable do
    url "https://github.com/gperftools/gperftools/releases/download/gperftools-2.9.1/gperftools-2.9.1.tar.gz"
    sha256 "ea566e528605befb830671e359118c2da718f721c27225cbbc93858c7520fee3"

    # Fix segfaults on Monterey.
    # https://github.com/gperftools/gperftools/pull/1315
    patch do
      url "https://github.com/gperftools/gperftools/commit/1000c64559ad5f624bec4d08657209d755c0a02a.patch?full_index=1"
      sha256 "93f58cb6fe6d0e22a7aadc1ad2ee60a45743e862e398387213024acad83de319"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/gperftools[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f34a3226e8eb39953b26b2bbed7303a0121644b78e45acd6dfba08d7ffb99585"
    sha256 cellar: :any,                 arm64_big_sur:  "1d97fc10af93886ac88a519c4807f9e73d84f71d6d11204c3b088302b8f6c8ed"
    sha256 cellar: :any,                 monterey:       "15e8c3c91094d9aa65556b42f75126a8884262cb0438ffa7efd227f521270484"
    sha256 cellar: :any,                 big_sur:        "c5402ce2e426620556c4dfbe0f57f68b7d42c96c84f0bbc667a02e6ee529eb7b"
    sha256 cellar: :any,                 catalina:       "48f3c365c6915e4cd815103d418bb98a49c3f7387266fc808d23de1aa2d5fb8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e00b341d2cbcf5b1bfa351308d3fdb34c74cd357149fcb8babbb2571ada9f44"
  end

  head do
    url "https://github.com/gperftools/gperftools.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  uses_from_macos "xz"

  on_linux do
    # libunwind is strongly recommended for Linux x86_64
    # https://github.com/gperftools/gperftools/blob/master/INSTALL
    depends_on "libunwind"
  end

  def install
    ENV.append_to_cflags "-D_XOPEN_SOURCE" if OS.mac?

    system "autoreconf", "-fiv" if build.head?

    args = [
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
    ]
    args << "--enable-libunwind" if OS.linux?

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <gperftools/tcmalloc.h>

      int main()
      {
        void *p1 = tc_malloc(10);
        assert(p1 != NULL);

        tc_free(p1);

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ltcmalloc", "-o", "test"
    system "./test"

    (testpath/"segfault.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>

      int main()
      {
        void *ptr = malloc(128);
        if (ptr == NULL) return 1;
        free(ptr);
        return 0;
      }
    EOS
    system ENV.cc, "segfault.c", "-L#{lib}", "-ltcmalloc", "-o", "segfault"
    system "./segfault"
  end
end
