class Gperftools < Formula
  desc "Multi-threaded malloc() and performance analysis tools"
  homepage "https://github.com/gperftools/gperftools"
  license "BSD-3-Clause"

  stable do
    url "https://github.com/gperftools/gperftools/releases/download/gperftools-2.10/gperftools-2.10.tar.gz"
    sha256 "83e3bfdd28b8bcf53222c3798d4d395d52dadbbae59e8730c4a6d31a9c3732d8"
  end

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/gperftools[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b6083efd21e2ba10f38b8d8884bec70a5ad96b60e4f159d700b88a4f32626dcf"
    sha256 cellar: :any,                 arm64_big_sur:  "53e182d8321912b58fa8a9e7989ac13d337323cea79c9a6865ca9aef8235fdad"
    sha256 cellar: :any,                 monterey:       "119236efb407004d2d1c794d3fa97ac2d903f6271f03ba49ee905e23b8230320"
    sha256 cellar: :any,                 big_sur:        "1e55694d046edcecc802b5ebb93529ba9515abc833c10f0612ac281174611643"
    sha256 cellar: :any,                 catalina:       "425c644c9b7956e9e5d25153c3020d98b1ac2eaada5dcc497a87c4f142a1c1c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bab264991e8d70ad7bde43cc3ce05077fd5560a808e8ac1c939dd1764deba29f"
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
