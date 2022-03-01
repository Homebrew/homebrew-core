class Cpl < Formula
  desc "ISO-C libraries for developing astronomical data-reduction tasks"
  homepage "https://www.eso.org/sci/software/cpl/"
  url "ftp://ftp.eso.org/pub/dfs/pipelines/libraries/cpl/cpl-7.2.1.tar.gz"
  sha256 "8bd6c4e14614408ee46f6c08192f2d53aa2d2e24129dda4fb7d826be65832199"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/cpl/"
    regex(/href=.*?cpl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "770ce25aba6f82238706ab78b6617bb507d7cf44c5fffaa10c9d281d3506d2c8"
    sha256 cellar: :any,                 arm64_big_sur:  "c6a5baeaeff3827d016354015a9efa9b2f2bc07e5ad9430972c100cdc0813f28"
    sha256 cellar: :any,                 monterey:       "6f0df169b9bf66c8fb4f759c27c5958596ea8ba7a089792bab8a944bb3015255"
    sha256 cellar: :any,                 big_sur:        "f1851a3f70f96604153373c751985797df4adf8e42c84ae131b7a8d663459f86"
    sha256 cellar: :any,                 catalina:       "765071ab6932cd4952d2237330a31f829c5ed71884d7468a530e2a0d13a67378"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93dde958ec8052039fb4ef6ea0f600d2b3ddb9fc69cfbf3b83918296d8f644ad"
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
