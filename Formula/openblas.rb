class Openblas < Formula
  desc "Optimized BLAS library"
  homepage "http://www.openblas.net/"
  url "https://github.com/xianyi/OpenBLAS/archive/v0.2.20.tar.gz"
  sha256 "5ef38b15d9c652985774869efd548b8e3e972e1e99475c673b25537ed7bcf394"
  revision 1
  head "https://github.com/xianyi/OpenBLAS.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "4a62a8e0a79f1f06c30ea4743ee02eba1599fc66cfc9812967b838093dca048d" => :high_sierra
    sha256 "31c10a9ff27fe87694c8ca729d7fdc919f872302479082cbb5e42d22a84d66b8" => :sierra
    sha256 "6aa065aea2afd4573b8d20ac24ae8fec6fd6bf71562e33c6d25c397b3cea8187" => :el_capitan
  end

  keg_only :provided_by_osx,
           "macOS provides BLAS and LAPACK in the Accelerate framework"

  option "with-openmp", "Enable parallel computations with OpenMP"
  needs :openmp if build.with? "openmp"

  depends_on "gcc" # for gfortran

  def install
    ENV["DYNAMIC_ARCH"] = "1" if build.bottle?
    ENV["USE_OPENMP"] = "1" if build.with? "openmp"

    # Must call in two steps
    system "make", "CC=#{ENV.cc}", "FC=gfortran", "libs", "netlib", "shared"
    system "make", "PREFIX=#{prefix}", "install"

    lib.install_symlink "libopenblas.dylib" => "libblas.dylib"
    lib.install_symlink "libopenblas.dylib" => "liblapack.dylib"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <math.h>
      #include "cblas.h"

      int main(void) {
        int i;
        double A[6] = {1.0, 2.0, 1.0, -3.0, 4.0, -1.0};
        double B[6] = {1.0, 2.0, 1.0, -3.0, 4.0, -1.0};
        double C[9] = {.5, .5, .5, .5, .5, .5, .5, .5, .5};
        cblas_dgemm(CblasColMajor, CblasNoTrans, CblasTrans,
                    3, 3, 2, 1, A, 3, B, 3, 2, C, 3);
        for (i = 0; i < 9; i++)
          printf("%lf ", C[i]);
        printf("\\n");
        if (fabs(C[0]-11) > 1.e-5) abort();
        if (fabs(C[4]-21) > 1.e-5) abort();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lopenblas",
                   "-o", "test"
    system "./test"
  end
end
