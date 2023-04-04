class Openblas < Formula
  desc "Optimized BLAS library"
  homepage "https://www.openblas.net/"
  url "https://github.com/xianyi/OpenBLAS/archive/v0.3.23.tar.gz"
  sha256 "5d9491d07168a5d00116cdc068a40022c3455bf9293c7cb86a65b1054d7e5114"
  license "BSD-3-Clause"
  head "https://github.com/xianyi/OpenBLAS.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e43a93b3c2ccb704d431d9a624f01e05aa464bd3287b115b1d9a476db0f48b8a"
    sha256 cellar: :any,                 arm64_monterey: "f0934714025281e16b90d1c66b781bc1dea133fedb22a7835cd974dbfbbb1b88"
    sha256 cellar: :any,                 arm64_big_sur:  "c093a341cbea15a7eb1912d12a477ca7e9163dd728f433f124f722d21d9cd74b"
    sha256 cellar: :any,                 ventura:        "014076e0b66f5db4b3211eb9ed8c18fc3d9ce4d3cbe901bfbd22facdc2ec2c01"
    sha256 cellar: :any,                 monterey:       "aa3c27424af57a25da8475b3dc2b8be40b7da4b9edcc303b311bd20bf5cdf8b9"
    sha256 cellar: :any,                 big_sur:        "f361cd5b6727ebe326792b4903b811a5dcd38f89ba9634b3c6f6ccf7b4115f9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08e872457fcd108a406de1ddfb5f96a749f4719b676b0cca86071b685764637d"
  end

  keg_only :shadowed_by_macos, "macOS provides BLAS in Accelerate.framework"

  depends_on "gcc" # for gfortran
  fails_with :clang

  def install
    ENV.runtime_cpu_detection
    ENV.deparallelize # build is parallel by default, but setting -j confuses it

    # The build log has many warnings of macOS build version mismatches.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
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
