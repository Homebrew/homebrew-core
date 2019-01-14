class BdwGc < Formula
  desc "Garbage collector for C and C++"
  homepage "https://www.hboehm.info/gc/"
  url "https://github.com/ivmai/bdwgc/releases/download/v8.0.2/gc-8.0.2.tar.gz"
  sha256 "4e8ca4b5b72a3a27971daefaa9b621f0a716695b23baa40b7eac78de2eeb51cb"

  bottle do
    cellar :any
    sha256 "456bcc98f7bfbf3450c0fe729940aae4819e8db6093799bcd00cdba1875201f4" => :mojave
    sha256 "2f2ac45b40864ad3cc08fbbfdad80336842bc2bc950277fce147a81daebd5558" => :high_sierra
    sha256 "43ec8fd9fc66fb60270a2380039a7af16124bb6748735d431d8add3e0d73cd7a" => :sierra
  end

  head do
    url "https://github.com/ivmai/bdwgc.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  depends_on "libatomic_ops" => :build
  depends_on "pkg-config" => :build

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
