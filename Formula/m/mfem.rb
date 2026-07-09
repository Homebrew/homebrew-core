class Mfem < Formula
  desc "Free, lightweight, scalable C++ library for FEM"
  homepage "https://mfem.org/"
  url "https://github.com/mfem/mfem/archive/refs/tags/v4.9.tar.gz"
  sha256 "ea3ac13e182c09f05b414b03a9bef7a4da99d45d67ee409112b8f11058447a7c"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/mfem/mfem.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "a54e5122fd7056a63b49ae8792030d8282ff6fcba6165a72736be929a8a7f4f5"
    sha256 cellar: :any, arm64_sequoia: "24fabdaf8c24694ccafd0aef12f7b7b91929d505d17b7ea1f37b2a75d86200cb"
    sha256 cellar: :any, arm64_sonoma:  "34395676344ef42170fd5e9e3a6098955b848618b3303fba25239e5833c1c0f2"
    sha256 cellar: :any, sonoma:        "53c833b0c1399ab4ad009ab7684f60ca0faa676277feaa8c6e129d07ee06f149"
    sha256 cellar: :any, arm64_linux:   "dd75e7123c0f6b0054c074c518b8d3cc21f29c950c9cb1b7d85109b87687c4ca"
    sha256 cellar: :any, x86_64_linux:  "3352b39f74d0b8eb05cce1d8c18fa67a91784fc3d026752a1c644cb0da4b935d"
  end

  depends_on "cmake" => :build
  depends_on "hypre"        # optional "mpi"
  depends_on "metis"        # optional "metis"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "suite-sparse"

  def install
    # fix `lib/cmake/mfem/MFEMConfig.cmake` file audit failure
    inreplace "config/cmake/MFEMConfig.cmake.in", "@CMAKE_CXX_COMPILER@", ENV.cxx

    # fix `share/mfem/config.mk` file audit failure
    inreplace "config/config.mk.in", "@MFEM_CXX@", ENV.cxx
    inreplace "config/config.mk.in", "@MFEM_HOST_CXX@", ENV.cxx

    args = [
      "-DBUILD_SHARED_LIBS=ON",
      "-DCMAKE_INSTALL_RPATH=#{rpath}",
      "-DMFEM_USE_MPI=YES",
      "-DMFEM_USE_METIS_5=YES",
      "-DMFEM_USE_SUITESPARSE=YES",
      "-DMFEM_USE_NETCDF=NO",
      "-DMFEM_USE_SUPERLU=NO",
    ]
    args << "-DMFEM_USE_LAPACK=YES" if OS.linux?
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples", "data"
  end

  test do
    cp_r pkgshare/"examples", testpath
    cp pkgshare/"data/star.mesh", testpath/"examples"
    system "make", "-C", testpath/"examples", "all", "MFEM_INSTALL_DIR=#{prefix}", "CONFIG_MK=#{pkgshare}/config.mk"
    args = ["-m", testpath/"examples/star.mesh", "--no-visualization"]
    system testpath/"examples/ex1", *args
    system "mpirun", "-np", "1", testpath/"examples/ex1p", *args
  end
end
