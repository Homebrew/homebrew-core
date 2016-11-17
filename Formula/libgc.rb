class Libgc < Formula
  desc "The Boehm-Demers-Weiser conservative garbage collector"
  homepage "http://www.hboehm.info/gc/"
  url "http://www.hboehm.info/gc/gc_source/gc-7.2g.tar.gz"
  sha256 "584e29e2f1be4a389ca30f78dcd2c991031e7d1e1eb3d7ce2a0f975218337c2f"

  def install
    system "./configure", "--disable-silent-rules", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-'EOS'.undent
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
          if (i % 100000 == 0)
            printf("Heap size = %zu\n", GC_get_heap_size());
        }
        return 0;
      }
    EOS

    system ENV.cc, "-lgc", "-o", "test", "test.c"
    system "./test"
  end
end
