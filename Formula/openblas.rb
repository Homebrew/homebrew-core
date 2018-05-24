class Openblas < Formula
  desc "Optimized BLAS library"
  homepage "https://www.openblas.net/"
  url "https://github.com/xianyi/OpenBLAS/archive/v0.3.0.tar.gz"
  sha256 "cf51543709abe364d8ecfb5c09a2b533d2b725ea1a66f203509b21a8e9d8f1a1"
  head "https://github.com/xianyi/OpenBLAS.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "57577356cefd497527bf2424ffb812469e96f516c653fcf7332af1348f4727f6" => :high_sierra
    sha256 "8bd8b0cec1d6bbe27f96e47b23816e1281c7d8bf9bd41bc4b7f19ec800ba6105" => :sierra
    sha256 "ac9ca44c22039bb242990db8e7c4181a85b674c424d1d66f03efe20649ad3753" => :el_capitan
  end

  keg_only :provided_by_macos,
           "macOS provides BLAS and LAPACK in the Accelerate framework"

  option "with-openmp", "Enable parallel computations with OpenMP"

  depends_on "gcc" # for gfortran

  fails_with :clang if build.with? "openmp"

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
