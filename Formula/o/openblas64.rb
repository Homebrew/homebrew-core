class Openblas64 < Formula
  desc "Optimized BLAS library"
  homepage "https://www.openblas.net/"
  url "https://github.com/OpenMathLib/OpenBLAS/archive/refs/tags/v0.3.31.tar.gz"
  sha256 "6dd2a63ac9d32643b7cc636eab57bf4e57d0ed1fff926dfbc5d3d97f2d2be3a6"
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
    sha256 cellar: :any,                 arm64_tahoe:   "323037b68d15849767eb83b9ab4713699fdbea58ab23a7daca129d3587e85634"
    sha256 cellar: :any,                 arm64_sequoia: "e09b4b74abd8b307ac0023dde157379319f435e70a3db9da0e575d83758eb3f4"
    sha256 cellar: :any,                 arm64_sonoma:  "7a72fba4c0c1723e5fffd590cdc6332ffdf548fb8f5bb184707dc64b27f74c9d"
    sha256 cellar: :any,                 sonoma:        "8e47cd44fadc91e0ca0798bfd7b978a9af9a4f62f3a0ad2becdcdebd795fce5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8648f7bf778b0c078cdb5aaac6eebc037dfe3363f02d384dbded413bc234ac4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09214737899815592e1ec220e5eb65e9804c44c2514513f59c1885971baf1c52"
  end

  keg_only "the headers conflict with `openblas`"

  depends_on "objconv" => :build
  depends_on "pkgconf" => :test
  depends_on "gcc" # for gfortran
  fails_with :clang

  # Fix configuration header on Linux Arm with GCC 12
  # https://github.com/OpenMathLib/OpenBLAS/pull/5606
  patch do
    url "https://github.com/OpenMathLib/OpenBLAS/commit/c077708852c7262b6bc0da6bc094b447e7ba7b3c.patch?full_index=1"
    sha256 "e59596a7bec1fa6c22c4bee20c8040faa15fa57aa6486acd99b9688aef15f4da"
  end

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
