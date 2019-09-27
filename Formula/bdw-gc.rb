class BdwGc < Formula
  desc "Garbage collector for C and C++"
  homepage "https://www.hboehm.info/gc/"
  url "https://github.com/ivmai/bdwgc/releases/download/v8.0.4/gc-8.0.4.tar.gz"
  sha256 "436a0ddc67b1ac0b0405b61a9675bca9e075c8156f4debd1d06f3a56c7cd289d"
  revision 1

  bottle do
    cellar :any
    sha256 "05219d7d030791e3c3e3751b36a603a710cce86dc63c97cc64ea6743b8828406" => :mojave
    sha256 "280e51afa899236777022c30b756fb4b87e034b9e23a5526c183fe3d0e24731c" => :high_sierra
    sha256 "6a4132230171a8bff236796655c87f453d9f711ea1d22a9e0d61ac05dc624394" => :sierra
  end

  head do
    url "https://github.com/ivmai/bdwgc.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  depends_on "libatomic_ops" => :build
  depends_on "pkg-config" => :build

  patch do
    # Required for v8.0.4. Support for green threads.
    url "https://github.com/ivmai/bdwgc/commit/5668de71107022a316ee967162bc16c10754b9ce.patch"
    sha256 "784ade9fe1c2668db77a3c08cd195cd7701331bdf8c9d160038cfce099b77e37"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-cplusplus",
                          "--enable-static"
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
