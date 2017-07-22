class Openblas < Formula
  desc "Optimized BLAS library"
  homepage "http://www.openblas.net/"
  head "https://github.com/xianyi/OpenBLAS.git", :branch => "develop"

  stable do
    url "https://github.com/xianyi/OpenBLAS/archive/v0.2.19.tar.gz"
    sha256 "9c40b5e4970f27c5f6911cb0a28aa26b6c83f17418b69f8e5a116bb983ca8557"

    # Change file comments to work around clang 3.9 assembler bug
    # https://github.com/xianyi/OpenBLAS/pull/982
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/9c8a1cc/openblas/openblas0.2.19.diff"
      sha256 "3ddabb73abf3baa4ffba2648bf1d9387bbc6354f94dd34eeef942f1b3e25c29a"
    end
  end

  bottle do
    cellar :any
    sha256 "c6adfc265c1c896dce168dad78dde108045fb2f97b4395b15dee02c3f287b716" => :sierra
    sha256 "60f23bbf885a52e920e0bdfdceeeb5aa5e8006caaf802f517c373b7f068d8671" => :el_capitan
    sha256 "559bae2d31a9f0853f9e884839c6fb439d530113a2c19af17079d638aec8244e" => :yosemite
  end

  keg_only :provided_by_osx,
           "macOS provides BLAS and LAPACK in the Accelerate framework"

  option "with-openmp", "Enable parallel computations with OpenMP"
  needs :openmp if build.with? "openmp"

  depends_on :fortran

  def install
    ENV["DYNAMIC_ARCH"] = "1" if build.bottle?
    ENV["USE_OPENMP"] = "1" if build.with? "openmp"

    # Must call in two steps
    system "make", "CC=#{ENV.cc}", "FC=#{ENV.fc}", "libs", "netlib", "shared"
    system "make", "PREFIX=#{prefix}", "install"

    lib.install_symlink "libopenblas.dylib" => "libblas.dylib"
    lib.install_symlink "libopenblas.dylib" => "liblapack.dylib"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
