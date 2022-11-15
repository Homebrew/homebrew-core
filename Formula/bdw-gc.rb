class BdwGc < Formula
  desc "Garbage collector for C and C++"
  homepage "https://www.hboehm.info/gc/"
  url "https://github.com/ivmai/bdwgc/releases/download/v8.2.2/gc-8.2.2.tar.gz"
  sha256 "f30107bcb062e0920a790ffffa56d9512348546859364c23a14be264b38836a0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8f459fdcd689018081c07cab95c6e2517a84a5751bff1d47c8e220fd2f757b49"
    sha256 cellar: :any,                 arm64_monterey: "01693d25c01c27b4ae2fc7c176f57c1c46849c24440f1da484df9a2e99074594"
    sha256 cellar: :any,                 arm64_big_sur:  "162892760401052a1a6d6cb183bb6683c18905377489b9bf50151a80c816f967"
    sha256 cellar: :any,                 ventura:        "6efb9e3ce48ce40a1072a4e8b7acb318450ac09e44483f859b83c2f9b132c772"
    sha256 cellar: :any,                 monterey:       "706ba9acedc825db1634868bc7be96ee5c919091e8481ecd2267f62b1cd3d803"
    sha256 cellar: :any,                 big_sur:        "a55727cc7d7a7dbc8f7e61aca70a94dc07dcaccbfbffc5f92fcdc77dec64eaa7"
    sha256 cellar: :any,                 catalina:       "68e76db2edce7a83e900ff4152317eeee7ebf1deb2780cc134d003f01774f248"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf417b645bd80dee68a64b42624218531754802db112e4f08570bb881692c1d6"
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
