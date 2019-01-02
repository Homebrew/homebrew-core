class Openblas < Formula
  desc "Optimized BLAS library"
  homepage "https://www.openblas.net/"
  url "https://github.com/xianyi/OpenBLAS/archive/v0.3.5.tar.gz"
  sha256 "0950c14bd77c90a6427e26210d6dab422271bc86f9fc69126725833ecdaa0e85"
  head "https://github.com/xianyi/OpenBLAS.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "8e793c793676bfcec1871086beb2388554af4f043bc913ae1c6ed225f0dd1b06" => :mojave
    sha256 "9b8be755e4700ab9e4d8f778682483f8f9353ee468ed7919f2607e3b3abcb933" => :high_sierra
    sha256 "82a17700bad90768044add63c810c6e530bb93f23542e4fd22bc6e50ea669ced" => :sierra
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
