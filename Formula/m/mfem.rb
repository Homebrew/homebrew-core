class Mfem < Formula
  desc "Free, lightweight, scalable C++ library for FEM"
  homepage "http://www.mfem.org/"
  url "https://github.com/mfem/mfem/archive/refs/tags/v4.6.tar.gz"
  sha256 "250bb6aa0fd5f6a6002c072d357656241ed38acfc750e43e87d8c36a8f8a4b4f"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/mfem/mfem.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3949eba231c4a87fd729d1936c0dca95a913be155e4a7dbb5eb31e9dced6fc3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbacadc5c5a9c0302c1b68719478ed3df5e8bf5c54ab13ef450fea6168d21b31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eef76fe0105da324c2ca10f1e6e7c539f4cd49c8f0dc6f22006214668f738445"
    sha256 cellar: :any_skip_relocation, sonoma:         "391b5efdaa7416cc5372a6b88c38e32a3c9fa3c011f73e14771dce1e7757181f"
    sha256 cellar: :any_skip_relocation, ventura:        "a4db139271b3d67a07d2e909ceaa067997b150f507322c1e26d2fd3b1a1114a9"
    sha256 cellar: :any_skip_relocation, monterey:       "d106de616a9e371d86da8686f89b9638bd61bc31ff255401d4c30e3109170bd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "001ef56bbdbbb8ce4522ca6ba972551501f1c3b95e8dad8701cc02f81abf7805"
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
