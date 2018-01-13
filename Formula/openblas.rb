class Openblas < Formula
  desc "Optimized BLAS library"
  homepage "http://www.openblas.net/"
  url "https://github.com/xianyi/OpenBLAS/archive/v0.2.20.tar.gz"
  sha256 "5ef38b15d9c652985774869efd548b8e3e972e1e99475c673b25537ed7bcf394"
  revision 1
  head "https://github.com/xianyi/OpenBLAS.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "ce8b1b057a2cc93d9bcbaae0c9483200dd2e2f04ab533456dfe13eb38c6ab96b" => :high_sierra
    sha256 "1bb0db6885551ec021c2267c8e7ea662ef4877ac8c2a9b590d920866f018aea3" => :sierra
    sha256 "15b53cdfdc5028719e559612ea41f432cfbd2d4448cc29202273636ff3980bf5" => :el_capitan
    sha256 "95bb17c1ffeb1f652d24d0d064241a822804818ab8a317a39918a4cfe740b905" => :yosemite
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
