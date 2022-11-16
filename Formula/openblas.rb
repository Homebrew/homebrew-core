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
    sha256 cellar: :any,                 arm64_ventura:  "5f2cdcefee737845c64dde7eefb0ceb4d0f022b9b639ec4c9a2f61fc5e4762a3"
    sha256 cellar: :any,                 arm64_monterey: "87d3c5c201cffc4daf672e9976eb19daa59b690e6fa247e68ad1f0c9df95d790"
    sha256 cellar: :any,                 arm64_big_sur:  "34e57867496112f8a0748db2d06243f7d197a171667326194cca86f7b6fb8fb4"
    sha256 cellar: :any,                 ventura:        "ed4ac5c0db2c2a0a7a3b5bf6f5caa8fdea324a4cd5d1d8bdf540bf4ab12ab866"
    sha256 cellar: :any,                 monterey:       "fbbdca509a96aab530e9eeebb003e70213a72d06220a89a5e36b56ad89ca0bf3"
    sha256 cellar: :any,                 big_sur:        "abe0a49a4ca741e4336a22eed745330166db8f8bce5bb21555e46ca46b9a8b6a"
    sha256 cellar: :any,                 catalina:       "896879bedb28f8515d323cb860f925c2b569db540576e865113fc1d2a082ff1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12a3cb2689a5b424b112e4de8f0c4af51cb3d5bd7990a17ed104294052e469cb"
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
