class Mfem < Formula
  desc "Free, lightweight, scalable C++ library for FEM"
  homepage "https://mfem.org/"
  url "https://github.com/mfem/mfem/archive/refs/tags/v4.9.tar.gz"
  sha256 "ea3ac13e182c09f05b414b03a9bef7a4da99d45d67ee409112b8f11058447a7c"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/mfem/mfem.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8974f38b6753c04fcea78d3cea7e8f09e9d00200c7c20f3c04aef3f7af64afc4"
    sha256 cellar: :any,                 arm64_sequoia: "2672c4cdedf6ae743fdf5de3d61bd1582c9edf08c484ec23a1fe174f2e274ebf"
    sha256 cellar: :any,                 arm64_sonoma:  "f91e29927107cb64ab3c32c6e1c1227b0b9108d5c671114721b6889235589852"
    sha256 cellar: :any,                 sonoma:        "e3fb59206a0af49d8b6d518b921b62533f38ac8f69c7e6d3615f147e75bb5560"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80164924078003ac86b7197f2e6b077dec14c55e2b4cf1511fddd5af2bd0addc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dec7c79abbe13b993334d214016e5284f433424bc9bb21f4bdfbcf50b37a22cd"
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
