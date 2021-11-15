class Cpl < Formula
  desc "ISO-C libraries for developing astronomical data-reduction tasks"
  homepage "https://www.eso.org/sci/software/cpl/"
  url "ftp://ftp.eso.org/pub/dfs/pipelines/libraries/cpl/cpl-7.1.4.tar.gz"
  sha256 "cb43adba7ab15e315fbfcba4e2d8b88fa56d29a5a16036a7f082621b8416bd6c"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/cpl/"
    regex(/href=.*?cpl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "7b2de6ed276784ff0a34ec7386c11539836fe6a8a16b3f9a6fc12062e7593372"
    sha256 cellar: :any,                 big_sur:       "f03c10e6918ff16d484174e91a78e900dc2270237370aa8e448be23f0bb0496a"
    sha256 cellar: :any,                 catalina:      "23a33f0c139d0c56928bd6aa9bc7612c4da460f33468adcdd2ab267c444300ae"
    sha256 cellar: :any,                 mojave:        "8dd0ea688094de418970818c68eada0a5ee6eca74e4a5b09e4ab2864b8d0837c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d3b59f3737480691d03897fd6d0131b8c35ae0f90b479f3220d20c52feb964e"
  end

  depends_on "cfitsio"
  depends_on "fftw"
  depends_on "wcslib"

  conflicts_with "gdal", because: "both install cpl_error.h"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    directory "libcext"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-cfitsio=#{Formula["cfitsio"].prefix}",
                          "--with-fftw=#{Formula["fftw"].prefix}",
                          "--with-wcslib=#{Formula["wcslib"].prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOF
      #include <cpl.h>
      int main(){
        cpl_init(CPL_INIT_DEFAULT);
        cpl_msg_info("hello()", "Hello, world!");
        cpl_end();
        return 0;
      }
    EOF
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lcplcore", "-lcext", "-o", "test"
    system "./test"
  end
end
