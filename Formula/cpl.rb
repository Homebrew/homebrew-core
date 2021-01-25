class Cpl < Formula
  desc "ISO-C libraries for developing astronomical data-reduction tasks"
  homepage "https://www.eso.org/sci/software/cpl/index.html"
  url "ftp://ftp.eso.org/pub/dfs/pipelines/libraries/cpl/cpl-7.1.2.tar.gz"
  mirror "https://src.fedoraproject.org/repo/pkgs/cpl/cpl-7.1.2.tar.gz/sha512/0835917153fdcf4e7908f9261e143dc54fe7b50dc7903c2041a23a1984554b94a99584def70a792d9fe44a42830bc2baee397635ce922848d514a580be59348a/cpl-7.1.2.tar.gz"
  sha256 "b6d20752420e2333e86d9a08c24a08057351a9fef97c32f5894e63fbfece463a"
  revision 6

  bottle do
    cellar :any
    sha256 "4585413a3561eea4a3443b1214dd1759e82853ca5273929e202a2c38ad526add" => :catalina
    sha256 "d9410e5fc7b4e1466f88233e8e5e925133257d3f33953a8ce91aee780d53db33" => :mojave
    sha256 "7a810f03ee554b573832fd30285a2fad70be6b9ad6b0e9936300130396f151cd" => :high_sierra
  end

  depends_on "cfitsio"
  depends_on "fftw"
  depends_on "wcslib"

  conflicts_with "gdal", because: "both install cpl_error.h"

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
