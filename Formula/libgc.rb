class Libgc < Formula
  desc "The Boehm-Demers-Weiser conservative garbage collector"
  homepage "http://www.hboehm.info/gc/"
  url "http://www.hboehm.info/gc/gc_source/gc-7.6.0.tar.gz"
  sha256 "a14a28b1129be90e55cd6f71127ffc5594e1091d5d54131528c24cd0c03b7d90"

  bottle do
    cellar :any
    sha256 "99877426181b0c152be5ff36c8dd499baf311dcdad3e9077213aba815937dec6" => :sierra
    sha256 "2876d79f771da642949673c98a876f25effbefaf1432d91c9643b6934cedccaa" => :el_capitan
    sha256 "7f1086d2ec668f06298f56a0a56c05c9258fd4e3a7d907846606d91c6a19aaea" => :yosemite
  end

  resource "libatomic_ops" do
    url "http://www.hboehm.info/gc/gc_source/libatomic_ops-7.4.4.tar.gz"
    sha256 "bf210a600dd1becbf7936dd2914cf5f5d3356046904848dcfd27d0c8b12b6f8f"
  end

  def install
    resource("libatomic_ops").stage("#{buildpath}/libatomic_ops")
    system "./configure", "--disable-silent-rules", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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

    system ENV.cc, "-lgc", "-o", "test", "test.c"
    system "./test"
  end
end
