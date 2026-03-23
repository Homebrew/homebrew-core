class Cp2k < Formula
  desc "Quantum chemistry and solid state physics software package"
  homepage "https://www.cp2k.org/"
  url "https://github.com/cp2k/cp2k/releases/download/v2026.1/cp2k-2026.1.tar.bz2"
  sha256 "4364c74bcffaa474bc234e11686b09550e4d06932acf2147a341e4f7679dd88e"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "07bc22355e467c9d4e8b65013e9d370b01d099fd011e3758b1371ce1acf9b5a0"
    sha256 arm64_sequoia: "76fb2d301939f06439dac5c3041d616e540facd946336d719aadbd0fb5d3c4d6"
    sha256 arm64_sonoma:  "1abf089ae43d3df9b99fccb910c35d608d7afa3d84dd95ce65e2aff6da503a14"
    sha256 sonoma:        "6bff1f36dd36d4a4da5d87625a4869e558d005388268638bb13065f3e58aa9fe"
    sha256 arm64_linux:   "2df56fdcdadda4a0f684872a13095d462fa64a9436c0358e2036b318562ed715"
    sha256 x86_64_linux:  "933366a7dfaa3353854c2e803c25bd9c8272a0fcd979e28c34abd230dab052a1"
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
        -DOpenMP_omp_LIBRARY=#{Formula["libomp"].opt_lib}/libomp.dylib
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
      libgomp = Formula["gcc"].opt_lib/"gcc/current/libgomp.dylib"
      refute Utils.binary_linked_to_library?(lib/"libcp2k.dylib", libgomp), "Unwanted linkage to libgomp!"
    end

    system Formula["open-mpi"].bin/"mpirun", bin/"cp2k.psmp", pkgshare/"tests/water.inp"
  end
end
