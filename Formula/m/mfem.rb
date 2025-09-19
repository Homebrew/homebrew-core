class Mfem < Formula
  desc "Free, lightweight, scalable C++ library for FEM"
  homepage "https://mfem.org/"
  url "https://github.com/mfem/mfem/archive/refs/tags/v4.8.tar.gz"
  sha256 "65472f732d273832c64b2c39460649dd862df674222c71bfa82cf2da76705052"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/mfem/mfem.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ac88bab6b5c93f7d87f5bcc1d0759af438d7d1b2df51af56a5d046a4ebfb9e3d"
    sha256 cellar: :any,                 arm64_sequoia: "bb5a4a26df2514afdc22b0c2c113972977f69d08f215a9cd76061bcdf4f54458"
    sha256 cellar: :any,                 arm64_sonoma:  "277537e5f261f748b80b10694d879edee4f466630910010d19845ce9f026e9d0"
    sha256 cellar: :any,                 arm64_ventura: "4e70d2abd91e5f0bbebe67e57a7c100090372520430923d8a9ce88c6b3ff9b0b"
    sha256 cellar: :any,                 sonoma:        "b96357702ef792b1efab68780c3f817b7f3e94e455e3ee3d023968386f9cf430"
    sha256 cellar: :any,                 ventura:       "478f94973d73e5d051867e087e08ea8131c1bcc5833aeb0122f3317eaeecc896"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f82f2ce00bdca773da25b025a96d5c7a18f857f182c9c0b0a5180500134c0883"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd773f4de9a8d70d6c53073032adb139af3873659c56d49af7a43b16b65bb709"
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
