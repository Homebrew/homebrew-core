class Mfem < Formula
  desc "Free, lightweight, scalable C++ library for FEM"
  homepage "https://mfem.org/"
  url "https://github.com/mfem/mfem/archive/refs/tags/v4.9.tar.gz"
  sha256 "ea3ac13e182c09f05b414b03a9bef7a4da99d45d67ee409112b8f11058447a7c"
  license "BSD-3-Clause"
  head "https://github.com/mfem/mfem.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "101c8e3e83b62c40a3899fd0d95f168b66e529da589924380c9607d7bfb0eca8"
    sha256 cellar: :any,                 arm64_sequoia: "21aa4adadf52b13e960f25b7816426b47bc05284de39e32552332f5523a799b2"
    sha256 cellar: :any,                 arm64_sonoma:  "61d6abd79f70c44c460f9ec3f5e411b498a3ea7f704493d76f14ba35e35d7672"
    sha256 cellar: :any,                 sonoma:        "ad4157f0519685df404faa70e5ad4806761fcf8b2769e54d0c8a6ed6894123a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "657a88fa562547e991d66bd11e23dc25f432055f28d87884ea7cfe4b523161fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c04f014021ebcd35574d4ba85e3a33932c4d48fb11eb4b863bcdf9fefe5ceb6"
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
