class BdwGc < Formula
  desc "Garbage collector for C and C++"
  homepage "http://www.hboehm.info/gc/"
  url "https://github.com/ivmai/bdwgc/releases/download/v7.6.2/gc-7.6.2.tar.gz"
  sha256 "bd112005563d787675163b5afff02c364fc8deb13a99c03f4e80fdf6608ad41e"

  bottle do
    sha256 "a6511c1691d84794accb76a7a984cd62a3d14c7970af0e5b850f28ab140fad5f" => :high_sierra
    sha256 "fcbf63ca7801f54e098335ba3f7968bbcdf600e30ac878c68d61061d5923b9f1" => :sierra
    sha256 "939e43625f304cc5d315f28147db4323da910e7ade2efddea01fade0c56faf48" => :el_capitan
    sha256 "a49e8aaa7f869a5c7dec0d4e38bb02f6be7e82a45341953f3e761716e3836ef2" => :yosemite
    sha256 "392bb21f15af6c0ea2a9edfe0641362672e9d7ce8d9fee121e6a64e6081f79b0" => :mavericks
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
