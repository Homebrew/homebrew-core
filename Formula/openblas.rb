class Openblas < Formula
  desc "Optimized BLAS library"
  homepage "https://www.openblas.net/"
  url "https://github.com/xianyi/OpenBLAS/archive/v0.3.21.tar.gz"
  sha256 "f36ba3d7a60e7c8bcc54cd9aaa9b1223dd42eaf02c811791c37e8ca707c241ca"
  license "BSD-3-Clause"
  head "https://github.com/xianyi/OpenBLAS.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9034c92afc8a068dcccc4e826c979f99c452125ba16b008835dd0400b7e350eb"
    sha256 cellar: :any,                 arm64_big_sur:  "ec3bdec50fac2c1b30aaa4e666f9e22e884b07dbf94a817a2b9dd64199181920"
    sha256 cellar: :any,                 monterey:       "5e07aef09e5cd4d7540d6b579b7043cceb31daa46f74ad84c1d0d6623e6e9d10"
    sha256 cellar: :any,                 big_sur:        "43a52e035c2f9e79db9c7354e6f15fd27f79faf4b088ead68c16509be154b9ee"
    sha256 cellar: :any,                 catalina:       "c1069d2149456229f15e81cd38294bed64309a104b5a2fb572419114805e9fa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d030974e97540b290292ec29c747de9209342e18b04e2254f51267b163eaec17"
  end

  keg_only :shadowed_by_macos, "macOS provides BLAS in Accelerate.framework"

  depends_on "gcc" # for gfortran
  fails_with :clang

  def install
    ENV.runtime_cpu_detection
    ENV.deparallelize # build is parallel by default, but setting -j confuses it

    # The build log has many warnings of macOS build version mismatches.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
    # Setting `DYNAMIC_ARCH` is broken with binutils 2.38.
    # https://github.com/xianyi/OpenBLAS/issues/3708
    # https://sourceware.org/bugzilla/show_bug.cgi?id=29435
    ENV["DYNAMIC_ARCH"] = "1" if OS.mac?
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
