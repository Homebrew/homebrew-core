class Mfem < Formula
  desc "Free, lightweight, scalable C++ library for FEM"
  homepage "http://www.mfem.org/"
  url "https://github.com/mfem/mfem/archive/refs/tags/v4.6.tar.gz"
  sha256 "250bb6aa0fd5f6a6002c072d357656241ed38acfc750e43e87d8c36a8f8a4b4f"
  license "BSD-3-Clause"
  head "https://github.com/mfem/mfem.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "292fbde591e849f8ab68227d2ce11c2413eb50b7aabde23023664a94bd1dde3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9346ba1c03ecd5af2ff25d86913786d604b9b89b8306b47319f82e63b78f44b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82f356f2539c0be8cbda5f3e3cdbfe2341f36d27ccc9740983e929259da95ede"
    sha256 cellar: :any_skip_relocation, sonoma:         "35d380c43b1b58588d7e39fdf17abcd1a9701fd2c42e6e28387a6cdc0f11ab58"
    sha256 cellar: :any_skip_relocation, ventura:        "f8ba072821194be67e0c5df9f75d327ea8bb41be7e62354cf98eac03c532785c"
    sha256 cellar: :any_skip_relocation, monterey:       "2b3f5d26158cc7086905036a770a2e240140433f1929f90700dc119c0f4f2c0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a55f727fbf719d8fb9f746dc38f0881e8aea1ddc7cba8cac6b0c58f1b8e75b0"
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
