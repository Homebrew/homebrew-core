class Openblas < Formula
  desc "Optimized BLAS library"
  homepage "https://www.openblas.net/"
  url "https://github.com/xianyi/OpenBLAS/archive/v0.3.20.tar.gz"
  sha256 "8495c9affc536253648e942908e88e097f2ec7753ede55aca52e5dead3029e3c"
  license "BSD-3-Clause"
  head "https://github.com/xianyi/OpenBLAS.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "91cdf5685c3b65a47dc807aea685bf5bb3f43ecfebcda8098aba9e2da9347b73"
    sha256 cellar: :any,                 arm64_big_sur:  "33e6385102e69ddd716d8eb818861e2e2e2c08de20e06d189ffd69115131ed03"
    sha256 cellar: :any,                 monterey:       "94914bbd7366b63241473f48150278a11cd39cea633795d951d9e56356a20948"
    sha256 cellar: :any,                 big_sur:        "06d8f2e9ada16fad830fb34a81820d412c2a872a17e4164958460ddad4c8d4ae"
    sha256 cellar: :any,                 catalina:       "ecb5e93e79f4e1d9db66b2fa0ef9e7a03cdd5346a6c41d957f5359a5e2c6a2d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "527574110c9429bdc49cde43400ed2956d8708678a8ae85696f29a5b718ac41e"
  end

  keg_only :shadowed_by_macos, "macOS provides BLAS in Accelerate.framework"

  depends_on "gcc" # for gfortran
  fails_with :clang

  def install
    ENV.runtime_cpu_detection
    ENV.deparallelize # build is parallel by default, but setting -j confuses it

    ENV["DYNAMIC_ARCH"] = "1"
    ENV["USE_OPENMP"] = "1"
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
