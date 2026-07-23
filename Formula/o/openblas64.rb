class Openblas64 < Formula
  desc "Optimized BLAS library"
  homepage "https://www.openblas.net/"
  url "https://github.com/OpenMathLib/OpenBLAS/archive/refs/tags/v0.3.34.tar.gz"
  sha256 "cd7e129868320cc2d033afa920e31202dfe0b8066a5b66661900ccc0f197dfed"
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
    sha256 cellar: :any, arm64_tahoe:   "ad0701a4ae17e4d0cb2b44b353c98c277d0eff01ce172ff4382d97832e3e0ca6"
    sha256 cellar: :any, arm64_sequoia: "cf29492c76448a831a2ffea618c20a1c494dc49dc878c586f1cc3c8c0816092a"
    sha256 cellar: :any, arm64_sonoma:  "18b40eb1afd95de1725b6363ccd405aac39eafea29f4384986a4ec60cdc31476"
    sha256 cellar: :any, sonoma:        "3876e6eeb58dd487117e9216d9754f2f22033ff8ca8d43c42d005f08f83e519d"
    sha256 cellar: :any, arm64_linux:   "ed1d54ddb12f375390ca80ecfe683775b9e85a1e3c2701ae37c136a0043dde6b"
    sha256 cellar: :any, x86_64_linux:  "7fa3bfcdc68988db2ed5a1accb4f615afcf52817432732a0c5ce578e0e73cc2d"
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

    # ld denied .o file renamed by objconv that is not 8-byte aligned
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if OS.mac? && DevelopmentTools.clang_build_version >= 1700

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
