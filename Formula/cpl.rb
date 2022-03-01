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
    sha256 cellar: :any,                 arm64_monterey: "da8457c751e9338f82ef767e03d273f81c8bdddec9dcecdcd2fa8ab60c480fbf"
    sha256 cellar: :any,                 arm64_big_sur:  "3c330ff1943f8cfb8a2811d2a0177e54787f1f5d21ccf4ab3b7e859a793d18dd"
    sha256 cellar: :any,                 monterey:       "4ce97389c62446da66ca046ea767e4d1d31b883a66d460037a625a1ae9b39c21"
    sha256 cellar: :any,                 big_sur:        "09277d7405b91d4665405f1f1859a87e6c8cff226db6b4bdf5861bf40d0066d5"
    sha256 cellar: :any,                 catalina:       "c7918433254e4e602f3396e128681bf03ce3b4dc0b9c4adf028668de81467e6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9535768b10473dd7463dab196c109799dd35775b576766858260f53a8e52a4f2"
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
