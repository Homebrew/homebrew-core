class Cpl < Formula
  desc "ISO-C libraries for developing astronomical data-reduction tasks"
  homepage "https://www.eso.org/sci/software/cpl/"
  url "ftp://ftp.eso.org/pub/dfs/pipelines/libraries/cpl/cpl-7.2.tar.gz"
  sha256 "cfcd5102b395c8b8475ffec165d72093a4859013471b98d4280a16437be7c129"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/cpl/"
    regex(/href=.*?cpl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "906865be993916e5eed530c831b72372f9f3fab84b950b198ca99429b194d330"
    sha256 cellar: :any,                 arm64_big_sur:  "ee121d537a5003eaa6a457bd738933fe2e52bed5a0e3125d3025d86bd745e440"
    sha256 cellar: :any,                 monterey:       "57bd81f75db262bab79a0c3db612dd03bccb75866394aae3b863e21f923d9c5a"
    sha256 cellar: :any,                 big_sur:        "51b815488f0c70955a9e09bf3b2064f1e07775cfb8d0b938019c1d1effdec27b"
    sha256 cellar: :any,                 catalina:       "aaacddaecbfda7479572eba563454cb77b7fcb736f35f40c682133520e2d736a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f28e4c6dae7a12243188c36bec922937d7ab4be84d1e9010cdc5df3b974e55eb"
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
