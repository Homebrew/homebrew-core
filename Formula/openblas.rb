class Openblas < Formula
  desc "Optimized BLAS library"
  homepage "https://www.openblas.net/"
  url "https://github.com/xianyi/OpenBLAS/archive/v0.3.3.tar.gz"
  sha256 "49d88f4494ae780e3d7fa51769c00d982d7cdb73e696054ac3baa81d42f13bab"
  head "https://github.com/xianyi/OpenBLAS.git", :branch => "develop"

  bottle do
    rebuild 1
    sha256 "27a016e4f304469322480bf63ca22858aeb552a5c32996676251c741115f3fd5" => :mojave
    sha256 "9d83d7ffa579907aba6e8ee168670d7cad2a23091cefe34a9cf9d3690915f6c5" => :high_sierra
    sha256 "eaa3fe7a25a94152c79bc40244aa87ae585081a268669e5c6489656277f22fe1" => :sierra
  end

  keg_only :provided_by_macos,
           "macOS provides BLAS and LAPACK in the Accelerate framework"

  option "with-openmp", "Enable parallel computations with OpenMP"

  depends_on "gcc" # for gfortran

  # Upstream fix for issue https://github.com/xianyi/OpenBLAS/issues/1735
  # "OpenBLAS : Program will terminate because you tried to start too many threads"
  patch do
    url "https://github.com/xianyi/OpenBLAS/commit/4d183e5567346f80f2ef97eb98f8601c47f8cb56.patch?full_index=1"
    sha256 "9b02860bd78252ed9f09abb65a62fff22c0aeca002757d503f5b643a11b744bf"
  end

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
