class BdwGc < Formula
  desc "Garbage collector for C and C++"
  homepage "http://www.hboehm.info/gc/"
  url "https://github.com/ivmai/bdwgc/releases/download/v7.6.2/gc-7.6.2.tar.gz"
  sha256 "bd112005563d787675163b5afff02c364fc8deb13a99c03f4e80fdf6608ad41e"

  bottle do
    cellar :any
    sha256 "d32b513240cc4fea5cd4c0148c2f5338f393528c9ebabecbaff210b3f4fe511e" => :high_sierra
    sha256 "adea8d4192119dc2cc29448e5a5d2f82845a9a090087d056a6b281ad0009f75e" => :sierra
    sha256 "2b5e7e9fdd5efb7b043fff8b38b0a9b9a7730bb669841acf692f73b3ae736b99" => :el_capitan
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
