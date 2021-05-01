class Openblas < Formula
  desc "Optimized BLAS library"
  homepage "https://www.openblas.net/"
  url "https://github.com/xianyi/OpenBLAS/archive/v0.3.15.tar.gz"
  sha256 "30a99dec977594b387a17f49904523e6bc8dd88bd247266e83485803759e4bbe"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/xianyi/OpenBLAS.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f7eaeb832b3d1e5438e57fe567862aab8d8e79e767db194d90ccf93687ecac78"
    sha256 cellar: :any, big_sur:       "12bf96c63f88eb14e560a3985f9688be855286a2d55fdacdd33fdcb7330706d8"
    sha256 cellar: :any, catalina:      "bb7cdf02a9ae5795c2cd2795021f5902fea6a29f8434dd9b1126fcb37308ec0a"
    sha256 cellar: :any, mojave:        "36240e1d6e802b2353e28bb770f1a48f821498e3695b15a3fb25d6db3d12a165"
  end

  keg_only :shadowed_by_macos, "macOS provides BLAS in Accelerate.framework"

  depends_on "gcc" # for gfortran
  fails_with :clang

  # Fix compile on ARM
  # https://github.com/xianyi/OpenBLAS/issues/3222
  patch do
    url "https://github.com/xianyi/OpenBLAS/commit/c90c23e78f24f37c6be877e37075463a4ba8f201.patch?full_index=1"
    sha256 "eb89ce6160fc896eb6668658c2e6fdc34942b5e39ed45d28af4673435a500cf5"
  end

  def install
    ENV["DYNAMIC_ARCH"] = "1"
    ENV["USE_OPENMP"] = "1"
    ENV["NO_AVX512"] = "1"
    # Force a large NUM_THREADS to support larger Macs than the VMs that build the bottles
    ENV["NUM_THREADS"] = "56"
    ENV["TARGET"] = case Hardware.oldest_cpu
    when :arm_vortex_tempest
      "VORTEX"
    else
      Hardware.oldest_cpu.upcase.to_s
    end

    # Must call in two steps
    system "make", "CC=#{ENV.cc}", "FC=gfortran", "libs", "netlib", "shared"
    system "make", "PREFIX=#{prefix}", "install"

    lib.install_symlink shared_library("libopenblas") => shared_library("libblas")
    lib.install_symlink shared_library("libopenblas") => shared_library("liblapack")
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
