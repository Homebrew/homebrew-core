class Openblas < Formula
  desc "Optimized BLAS library"
  homepage "https://www.openblas.net/"
  url "https://github.com/xianyi/OpenBLAS/archive/refs/tags/v0.3.26.tar.gz"
  sha256 "4e6e4f5cb14c209262e33e6816d70221a2fe49eb69eaf0a06f065598ac602c68"
  license "BSD-3-Clause"
  head "https://github.com/xianyi/OpenBLAS.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "36624d7bad32e7c04b02048425f5bcc61a6f72da63402341140ebaad2151e1a0"
    sha256 cellar: :any,                 arm64_ventura:  "a0ec409e1f75cb6a87855e28cfdd8c0063fd6c4989f4b3c7363b80c1d36080d5"
    sha256 cellar: :any,                 arm64_monterey: "e07caf8dfbb385473b6073da1cad9df4484632eb9ab590067fe912915cc5a6c2"
    sha256 cellar: :any,                 sonoma:         "c7611d8b5a79d4a8d046a9c16c94f76730ef7830d4a912bc6b951bc1cbd734c6"
    sha256 cellar: :any,                 ventura:        "d6fddc1f52c293f3cb359c8b5681475d0fdbf51462d5d99ce6ce51e77b06b423"
    sha256 cellar: :any,                 monterey:       "f714f5fcfe7a2e71d4aca6eab158b4f342064488a6f047ced9d62a40e2f0216c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "630227887138baec6555d46abca8e48785fc6e3467f6ee07740b197c3695aaab"
  end

  keg_only :shadowed_by_macos, "macOS provides BLAS in Accelerate.framework"

  depends_on "gcc" # for gfortran
  fails_with :clang

  def install
    ENV.runtime_cpu_detection
    ENV.deparallelize # build is parallel by default, but setting -j confuses it

    # The build log has many warnings of macOS build version mismatches.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s if OS.mac?
    ENV["DYNAMIC_ARCH"] = "1"
    ENV["USE_OPENMP"] = "1"
    # Force a large NUM_THREADS to support larger Macs than the VMs that build the bottles
    ENV["NUM_THREADS"] = "56"
    # See available targets in TargetList.txt
    ENV["TARGET"] = case Hardware.oldest_cpu
    when :arm_vortex_tempest
      "VORTEX"
    when :westmere
      "NEHALEM"
    else
      Hardware.oldest_cpu.upcase.to_s
    end

    # Apple Silicon does not support SVE
    # https://github.com/xianyi/OpenBLAS/issues/4212
    ENV["NO_SVE"] = "1" if Hardware::CPU.arm?

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
