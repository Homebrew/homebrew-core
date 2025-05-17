class Openblas < Formula
  desc "Optimized BLAS library"
  homepage "https://www.openblas.net/"
  # The main license is BSD-3-Clause. Additionally,
  # 1. OpenBLAS is based on GotoBLAS2 so some code is under original BSD-2-Clause-Views
  # 2. lapack-netlib/ is a bundled LAPACK so it is BSD-3-Clause-Open-MPI
  # 3. interface/{gemmt.c,sbgemmt.c} is BSD-2-Clause
  # 4. relapack/ is MIT but license is omitted as it is not enabled
  license all_of: ["BSD-3-Clause", "BSD-2-Clause-Views", "BSD-3-Clause-Open-MPI", "BSD-2-Clause"]
  head "https://github.com/OpenMathLib/OpenBLAS.git", branch: "develop"

  stable do
    url "https://github.com/OpenMathLib/OpenBLAS/archive/refs/tags/v0.3.29.tar.gz"
    sha256 "38240eee1b29e2bde47ebb5d61160207dc68668a54cac62c076bb5032013b1eb"

    # Remove patch in the next release
    patch do
      url "https://github.com/OpenMathLib/OpenBLAS/commit/70865a894e5963724ff9ccb05323ac2234a918b9.patch?full_index=1"
      sha256 "80beeb28e5baf21af05ac114a1cca97855faf298e40b3b290005977fad260f52"
    end

    # Remove patch in the next release
    patch do
      url "https://github.com/OpenMathLib/OpenBLAS/commit/d659f3c3f6058ece8a704423b72ece3821cfba4d.patch?full_index=1"
      sha256 "88ad7b0802e914535dcb8ceedfaec6cc01d379d2029111c29a7b55176a511f88"
    end

    # Remove patch in the next release
    patch do
      url "https://github.com/OpenMathLib/OpenBLAS/commit/9aa7a0b2a7b2770adec6ff26b34660d3bcd8c49c.patch?full_index=1"
      sha256 "0538ce7223ec5813c80e148388e892184b5e5e396c0868f903c8c0c5e19c5c2e"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0cef0ab521810fae27b78f5d9f0a2fc42a74d52b568b70b2a5ecc229711c0920"
    sha256 cellar: :any,                 arm64_sonoma:  "88e8c3f9d4af71ebfcd068cdc95017deda958d2666fb29de1c88f8f77dd8d57d"
    sha256 cellar: :any,                 arm64_ventura: "3a0e4b4da3526b6e939d51f9ae3d5d3123b3e70a28962384851f04a521475b71"
    sha256 cellar: :any,                 sonoma:        "56dc157bbb4fae7ac26abe2e481d5fa0cb76062c84d8da88cf3cf1cb17ff4ba0"
    sha256 cellar: :any,                 ventura:       "15432ddfd653901f19a86b6377458ba442f10112569b2b8cf60e5fe5e7b2c178"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ced93cd8441bd4939aa2835000ba3a8ea0394cb850594b20077798ce9605b940"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20cfbd105f1fd674475da44c41fda406ac10a9cf8d1ae521b337ad046e957a29"
  end

  keg_only :shadowed_by_macos, "macOS provides BLAS in Accelerate.framework"

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  depends_on "gcc" # for gfortran

  on_macos do
    depends_on "libomp"
  end

  def install
    ENV.runtime_cpu_detection

    target = case Hardware.oldest_cpu
    when :arm_vortex_tempest
      "VORTEX"
    when :westmere
      "NEHALEM"
    else
      Hardware.oldest_cpu.upcase.to_s
    end

    args = %W[
      -DUSE_OPENMP=ON
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_STATIC_LIBS=ON
      -DNUM_THREADS=64
      -DTARGET=#{target}
    ]

    args << "-DDYNAMIC_ARCH=ON" if !OS.mac? || Hardware::CPU.intel?

    if OS.mac?
      libomp = Formula["libomp"]
      args << "-DOpenMP_Fortran_LIB_NAMES=omp"
      args << "-DOpenMP_omp_LIBRARY=#{libomp.opt_lib}/libomp.dylib"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    lib.install_symlink shared_library("libopenblas") => shared_library("libblas")
    lib.install_symlink shared_library("libopenblas") => shared_library("liblapack")

    inreplace lib/"pkgconfig/openblas.pc", prefix, opt_prefix
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
        cblas_dgemm(CblasColMajor, CblasNoTrans, CblasTrans,
                    3, 3, 2, 1, A, 3, B, 3, 2, C, 3);
        for (i = 0; i < 9; i++)
          printf("%lf ", C[i]);
        printf("\\n");
        if (fabs(C[0]-11) > 1.e-5) abort();
        if (fabs(C[4]-21) > 1.e-5) abort();
        return 0;
      }
    C

    ENV.prepend_path "PKG_CONFIG_PATH", lib/"pkgconfig"
    flags = shell_output("pkgconf --cflags --libs openblas").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
