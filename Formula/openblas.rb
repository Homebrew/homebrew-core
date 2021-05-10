class Openblas < Formula
  desc "Optimized BLAS library"
  homepage "https://www.openblas.net/"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/xianyi/OpenBLAS.git", branch: "develop"

  stable do
    url "https://github.com/xianyi/OpenBLAS/archive/v0.3.15.tar.gz"
    sha256 "30a99dec977594b387a17f49904523e6bc8dd88bd247266e83485803759e4bbe"

    # Fix compile on ARM
    # https://github.com/xianyi/OpenBLAS/issues/3222
    patch do
      url "https://github.com/xianyi/OpenBLAS/commit/c90c23e78f24f37c6be877e37075463a4ba8f201.patch?full_index=1"
      sha256 "eb89ce6160fc896eb6668658c2e6fdc34942b5e39ed45d28af4673435a500cf5"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256               arm64_big_sur: "d6a3a72eab5bdf20737b24e4ca142ce9f1de7facf296692a1cb427f6991738a3"
    sha256 cellar: :any, big_sur:       "fa68f6847227743daa07f70be8e0436e43575bea3c3fb2a2672521afa9c4766f"
    sha256 cellar: :any, catalina:      "053e13fbeb193ed30add73eb3afdec1f8f97314a00dfd328f2c18b66624e6161"
    sha256 cellar: :any, mojave:        "891c7cc3bc0d6f99829558bc7ee557d3a3511398ab9cccab4783c9c6843d498b"
  end

  keg_only :shadowed_by_macos, "macOS provides BLAS in Accelerate.framework"

  depends_on "gcc" # for gfortran
  fails_with :clang

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
