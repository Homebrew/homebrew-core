class Cp2k < Formula
  desc "Quantum chemistry and solid state physics software package"
  homepage "https://www.cp2k.org/"
  url "https://github.com/cp2k/cp2k/releases/download/v2026.1/cp2k-2026.1.tar.bz2"
  sha256 "4364c74bcffaa474bc234e11686b09550e4d06932acf2147a341e4f7679dd88e"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "bd9a464326b7591cb5bf842b784d6952e25d7c0c21d39e765e0b67056156cbf2"
    sha256 arm64_sequoia: "743932d72c7e8bf400567269abce5c17708a793b422ec516bf006ccc61d868e2"
    sha256 arm64_sonoma:  "c4e0797a62da883c30016a3f11315afa13040ee5178e521c03623a4d1369d7c5"
    sha256 sonoma:        "d45a04f72f52d4bab88b2c3589eb3125f52e70c48c0274115d4dfcf9c33da7f1"
    sha256 arm64_linux:   "a0d75f2e4049cb258e44e05e8bfb911e329f1a2e499f8eb28a5116b72391095e"
    sha256 x86_64_linux:  "41292262c9b62ce0818116e8acbca005888d7dbd9016bfa4a61325b8aad39b61"
  end

  depends_on "cmake" => :build
  depends_on "fypp" => :build
  depends_on "pkgconf" => :build

  depends_on "dbcsr"
  depends_on "fftw"
  depends_on "gcc" # for gfortran
  depends_on "libint"
  depends_on "libxc"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "scalapack"

  uses_from_macos "python" => :build

  on_macos do
    depends_on "libomp"
  end

  def install
    # Avoid over-optimizing fortran code as we don't have a shim for gfortran
    optflags = ENV["HOMEBREW_OPTFLAGS"].to_s.split.join(";")
    inreplace "cmake/CompilerConfiguration.cmake", "-march=native;-mtune=native", optflags

    # Avoid trying to access /proc/self/statm on macOS
    ENV.append "FFLAGS", "-D__NO_STATM_ACCESS" if OS.mac?

    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCP2K_BLAS_VENDOR=OpenBLAS
      -DCP2K_USE_FFTW3=ON
      -DCP2K_USE_LIBINT2=ON
      -DCP2K_USE_LIBXC=ON
      -DCP2K_USE_MPI=ON
      -DCP2K_USE_MPI_F08=ON
    ]
    if OS.mac?
      args += %W[
        -DOpenMP_Fortran_LIB_NAMES=omp
        -DOpenMP_omp_LIBRARY=#{formula_opt_lib("libomp")}/libomp.dylib
      ]
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    (pkgshare/"tests").install "tests/Fist/water.inp"
  end

  test do
    if OS.mac?
      require "utils/linkage"
      libgomp = formula_opt_lib("gcc")/"gcc/current/libgomp.dylib"
      refute Utils.binary_linked_to_library?(lib/"libcp2k.dylib", libgomp), "Unwanted linkage to libgomp!"
    end

    system Formula["open-mpi"].bin/"mpirun", bin/"cp2k.psmp", pkgshare/"tests/water.inp"
  end
end
