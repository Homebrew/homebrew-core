class BdwGc < Formula
  desc "Garbage collector for C and C++"
  homepage "http://www.hboehm.info/gc/"
  url "https://github.com/ivmai/bdwgc/releases/download/v7.6.8/gc-7.6.8.tar.gz"
  sha256 "040ac5cdbf1bebc7c8cd4928996bbae0c54497c151ea5639838fa0128102e258"

  bottle do
    cellar :any
    sha256 "92c0083a6b6ae87607e13185a59e3f1794b543f7172889777bc09c0e9c1e158b" => :high_sierra
    sha256 "ccd948680c4d35ea36968605a7e51e038187b8492c7888369a180659905b200c" => :sierra
    sha256 "13cd1da271d203af0e834a53f232122ab0a740bf9bbb68c68cc172bd23654eab" => :el_capitan
  end

  head do
    url "https://github.com/ivmai/bdwgc.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libatomic_ops" => :build

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-cplusplus"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <stdio.h>
      #include "gc.h"

      int main(void)
      {
        int i;

        GC_INIT();
        for (i = 0; i < 10000000; ++i)
        {
          int **p = (int **) GC_MALLOC(sizeof(int *));
          int *q = (int *) GC_MALLOC_ATOMIC(sizeof(int));
          assert(*p == 0);
          *p = (int *) GC_REALLOC(q, 2 * sizeof(int));
        }
        return 0;
      }
    EOS

    system ENV.cc, "-I#{include}", "-L#{lib}", "-lgc", "-o", "test", "test.c"
    system "./test"
  end
end
