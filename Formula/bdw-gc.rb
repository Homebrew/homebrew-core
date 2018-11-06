class BdwGc < Formula
  desc "Garbage collector for C and C++"
  homepage "https://www.hboehm.info/gc/"
  url "https://github.com/ivmai/bdwgc/releases/download/v8.0.0/gc-8.0.0.tar.gz"
  sha256 "8f23f9a20883d00af2bff122249807e645bdf386de0de8cbd6cce3e0c6968f04"

  bottle do
    cellar :any
    sha256 "54404df7c3199dcdf7ac78df64791b36ef3fb841eb32d7e7e5130c6bd9fbfb8f" => :mojave
    sha256 "ba0c4e665f50956ebe41269a91c812e5c752828cb669ea83d9ed76965ed8f4eb" => :high_sierra
    sha256 "e77147a4e1bd4cb5d007ca98ff8792f2ae769b2ee8029d59eb52fec5d23140a7" => :sierra
    sha256 "00146ac7fa9bdb2f06788ebe3f1a33bff19a2c26f431cd78d51507764ba39558" => :el_capitan
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
