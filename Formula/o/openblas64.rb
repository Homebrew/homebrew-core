class Openblas64 < Formula
  desc "Optimized BLAS library"
  homepage "https://www.openblas.net/"
  url "https://github.com/OpenMathLib/OpenBLAS/archive/refs/tags/v0.3.30.tar.gz"
  sha256 "27342cff518646afb4c2b976d809102e368957974c250a25ccc965e53063c95d"
  # The main license is BSD-3-Clause. Additionally,
  # 1. OpenBLAS is based on GotoBLAS2 so some code is under original BSD-2-Clause-Views
  # 2. lapack-netlib/ is a bundled LAPACK so it is BSD-3-Clause-Open-MPI
  # 3. interface/{gemmt.c,sbgemmt.c} is BSD-2-Clause
  # 4. relapack/ is MIT but license is omitted as it is not enabled
  license all_of: ["BSD-3-Clause", "BSD-2-Clause-Views", "BSD-3-Clause-Open-MPI", "BSD-2-Clause"]
  head "https://github.com/OpenMathLib/OpenBLAS.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8899867d228f7316c37e782107ecb612f143972f7a2a1341e7db605655fee883"
    sha256 cellar: :any,                 arm64_sequoia: "ea0034f6593d99bdc6ff3aee1a87230e56a68ae2fa6a7aca7035d7b5edf5c222"
    sha256 cellar: :any,                 arm64_sonoma:  "9334ed383743828179e954dc50afcb2f23cd969b6205ac70c8edeb88e6a55c20"
    sha256 cellar: :any,                 sonoma:        "b3cc1a88e1e76a8e78393ffa503e0589a7a11252722e1d823245f682a136e398"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc783506f2fc87c6ab3990e8b852f488ac342a025ee19028c0cbfec4c72ffe05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "930cf8ef811f2bf037e07a2448db3eb339e039727b36dbc319bd630a3943db63"
  end

  keg_only "the headers conflict with `openblas`"

  depends_on "objconv" => :build
  depends_on "pkgconf" => :test
  depends_on "gcc" # for gfortran
  fails_with :clang

  def install
    ENV.runtime_cpu_detection
    ENV.deparallelize # build is parallel by default, but setting -j confuses it

    # Use 64-bit integers (ILP64 model)
    ENV["INTERFACE64"] = "1"
    ENV["SYMBOLSUFFIX"] = "64_"

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
    # https://github.com/OpenMathLib/OpenBLAS/issues/4212
    ENV["NO_SVE"] = "1" if Hardware::CPU.arm?

    # Must call in two steps
    system "make", "CC=#{ENV.cc}", "FC=gfortran", "libs", "netlib", "shared"
    system "make", "PREFIX=#{prefix}", "install"

    lib.install_symlink shared_library("libopenblas64_") => shared_library("libblas64_")
    lib.install_symlink shared_library("libopenblas64_") => shared_library("liblapack64_")
    pkgshare.install "cpp_thread_test"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>
      #include <math.h>
      #include "cblas.h"

      int main(void) {
        int i;
        double A[6] = {1.0, 2.0, 1.0, -3.0, 4.0, -1.0};
        double B[6] = {1.0, 2.0, 1.0, -3.0, 4.0, -1.0};
        double C[9] = {.5, .5, .5, .5, .5, .5, .5, .5, .5};
        cblas_dgemm64_(CblasColMajor, CblasNoTrans, CblasTrans,
                       3, 3, 2, 1, A, 3, B, 3, 2, C, 3);
        for (i = 0; i < 9; i++)
          printf("%lf ", C[i]);
        printf("\\n");
        if (fabs(C[0]-11) > 1.e-5) abort();
        if (fabs(C[4]-21) > 1.e-5) abort();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lopenblas64_", "-o", "test"
    system "./test"

    cp_r pkgshare/"cpp_thread_test/.", testpath
    ENV.prepend_path "PKG_CONFIG_PATH", lib/"pkgconfig"
    flags = shell_output("pkgconf --cflags --libs openblas64").chomp.split
    %w[dgemm_thread_safety dgemv_thread_safety].each do |test|
      inreplace "#{test}.cpp", '"../cblas.h"', '"cblas.h"'
      # Call the functions suffixed by "64_"
      inreplace "#{test}.cpp", /(cblas_dgem[mv])\(CblasColMajor/, "\\164_(CblasColMajor"
      system ENV.cxx, *ENV.cxxflags.to_s.split, "-std=c++11", "#{test}.cpp", "-o", test, *flags
      system "./#{test}"
    end
  end
end
