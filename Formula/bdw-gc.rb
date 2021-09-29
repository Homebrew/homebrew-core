class BdwGc < Formula
  desc "Garbage collector for C and C++"
  homepage "https://www.hboehm.info/gc/"
  license "MIT"

  # Remove stable block when patch is removed
  stable do
    url "https://github.com/ivmai/bdwgc/releases/download/v8.0.6/gc-8.0.6.tar.gz"
    sha256 "3b4914abc9fa76593596773e4da671d7ed4d5390e3d46fbf2e5f155e121bea11"

    # Extension to handle multithreading. Remove in v8.2.0.
    # https://github.com/ivmai/bdwgc/pull/277
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/f14c259aef209e5f5df302b834b2119381dd36d5/bdw-gc/crystal-mt.patch"
      sha256 "18380da9c5451c9b7668ccf5e1f106f8cf8115992d9a403e32444fb487566c33"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "ee743d115b619b02230863812224a1c33dc1d3430280728eb10990cc86caa994"
    sha256 cellar: :any,                 big_sur:       "af8bfafe1425f3cc9923bd49a375f85c13255124ed7a952137fe924431adc1c4"
    sha256 cellar: :any,                 catalina:      "73a3a75a47a0007a772fe229f11bc0710988af6a8603c56a0f7fae3d9a317149"
    sha256 cellar: :any,                 mojave:        "960f60118f6f5cbf4e04a76e4c2103c7fb446e43e5db08362bca0b13763e137b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05ea8f4b5dbc0329c01a525ff30a2c00f45bca54c03f2460e88d7f4d39e65686"
  end

  head do
    url "https://github.com/ivmai/bdwgc.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  depends_on "libatomic_ops" => :build
  depends_on "pkg-config" => :build

  on_linux do
    depends_on "gcc" => :test
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-cplusplus",
                          "--enable-static",
                          "--enable-large-config"
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

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lgc", "-o", "test"
    system "./test"
  end
end
