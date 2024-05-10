class Mfem < Formula
  desc "Free, lightweight, scalable C++ library for FEM"
  homepage "http://www.mfem.org/"
  url "https://github.com/mfem/mfem/archive/refs/tags/v4.7.tar.gz"
  sha256 "731bc2665c13d4099f9c9c946eb83ab07cd2e78a9575d4fa62a96cdb40d6ba0f"
  license "BSD-3-Clause"
  head "https://github.com/mfem/mfem.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "caeb6d44d99d2b8c681539b8c6fcd2139eca0079e9427eff4cc20df9b5b12067"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "abbe3f843317bde2dcd3f396cbc4f132e53f4601ca63712e790c5819b90f19ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42815e0cca7be31b3b2ad59e9ba48dc79f9c998b051666a22bd0c5eed18cc723"
    sha256 cellar: :any_skip_relocation, sonoma:         "410e2f119420078698e8e4c52c7792e045b28771cc48e3735ab94941a10db203"
    sha256 cellar: :any_skip_relocation, ventura:        "3ec94b67bd753a1d01768c3dcd68e28b3cf87d6683c8fd5ed01115e495647386"
    sha256 cellar: :any_skip_relocation, monterey:       "f4a349a5fef6c5ad572fd3392ebc70851e65c947a9e1d81045ed45378b973233"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c36512101f6aff6a51c2fdf1a5374a2ad899b22e3242316b142f8f8b892bf85"
  end

  depends_on "cmake" => :build
  depends_on "hypre"        # optional "mpi"
  depends_on "metis"        # optional "metis"
  depends_on "openblas"
  depends_on "suite-sparse"

  def install
    # fix `lib/cmake/mfem/MFEMConfig.cmake` file audit failure
    inreplace "config/cmake/MFEMConfig.cmake.in", "@CMAKE_CXX_COMPILER@", ENV.cxx

    # fix `share/mfem/config.mk` file audit failure
    inreplace "config/config.mk.in", "@MFEM_CXX@", ENV.cxx
    inreplace "config/config.mk.in", "@MFEM_HOST_CXX@", ENV.cxx

    args = [
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
