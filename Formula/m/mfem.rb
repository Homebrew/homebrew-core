class Mfem < Formula
  desc "Free, lightweight, scalable C++ library for FEM"
  homepage "https://mfem.org/"
  url "https://github.com/mfem/mfem/archive/refs/tags/v4.8.tar.gz"
  sha256 "65472f732d273832c64b2c39460649dd862df674222c71bfa82cf2da76705052"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/mfem/mfem.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9f2c75c87ae6c6287e7b47206494d25129be0c29604dee11c6f31db8c7396461"
    sha256 cellar: :any,                 arm64_sequoia: "206d35c1e7363b016d0db71587a929bf159935baebe38612873b4d77aaa0b21f"
    sha256 cellar: :any,                 arm64_sonoma:  "b9f0579107be2a9c6f3ba45e4c7c81ce842ad7c4caf1d24f9ab11938dfc4e4db"
    sha256 cellar: :any,                 sonoma:        "f8b98c0b761151593d3a2d87fbdfa41b2a25f850a5f79641612aaa9f51eac0cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c03044cdec3a8cf55403e7c0ff67d0b6cb4e4f008ffa64d6b3a53382342c43b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45e7d9d5a3b6573e91b176cc3d8a10b746d5b62cd24a8a1a06cdea0afb87b532"
  end

  depends_on "cmake" => :build
  depends_on "hypre"        # optional "mpi"
  depends_on "metis"        # optional "metis"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "suite-sparse"

  # build patch to support Hypre 3.0, bug report, https://github.com/mfem/mfem/issues/5042
  # upstream pr ref, https://github.com/mfem/mfem/pull/4975
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/mfem/4.8-support-hypre-3.0.patch"
    sha256 "e490973f6b74f71c54f6449a8832575eb96c1562468210c444847109470d114f"
  end

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
