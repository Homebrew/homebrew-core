class Mfem < Formula
  desc "Free, lightweight, scalable C++ library for FEM"
  homepage "https://mfem.org/"
  url "https://github.com/mfem/mfem/archive/refs/tags/v4.10.tar.gz"
  sha256 "d5aabe991b8b5569aa26e2b5d4b59ac617ee10ebac3d45fd6ff9c74b2c1a47dd"
  license "BSD-3-Clause"
  head "https://github.com/mfem/mfem.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ac1f123bec4f991b171e83c7a8d0bb7c77ae54f2dc7cb3dee96e4744d878aedf"
    sha256 cellar: :any, arm64_tahoe:       "46242c48b61f80f57bd26ee0dd2a1afd56d1c09ab4329e1a08ef36b00aed530e"
    sha256 cellar: :any, arm64_sequoia:     "26f2daf4dda7fa640f3da037c99a0ee542433b3feb96e215074f6c6f14255b78"
    sha256 cellar: :any, arm64_sonoma:      "166908a8d88bee3f06765e1cefa05241dc3ff2dd0f8c3e72be76ded3ac7539a3"
    sha256 cellar: :any, arm64_linux:       "5d6fedfee8aaed6933bf7ca49974710333d0dffe9cfdd8adac131c77c63e6ec2"
    sha256 cellar: :any, x86_64_linux:      "37bf1ddc4a9b1b1338749ec0d12b3d43c460866cd86eb7da48a41646a098cb41"
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
