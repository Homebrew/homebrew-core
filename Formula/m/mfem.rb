class Mfem < Formula
  desc "Free, lightweight, scalable C++ library for FEM"
  homepage "http://www.mfem.org/"
  url "https://github.com/mfem/mfem/archive/refs/tags/v4.5.2.tar.gz"
  sha256 "9431d72a2834078f25c58430767bf2fd62bf43a0feb003189a86847c68b8af4a"
  license "BSD-3-Clause"
  head "https://github.com/mfem/mfem.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b7a3ed63a7e5f44598a10355e58efb02967d6d0a7d91021a7f70ee785a3d769"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4757c720028fd0d2c596d94eddc0d2e57f23bd11a6b7d50750ecf76dccde2fd7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "584ef622c88ff2ea7173634385776fb292f838d752be5830c018368644615da7"
    sha256 cellar: :any_skip_relocation, ventura:        "c10c51c3dfab840d9d6a2ccb6872886404b6cf847935302a79ddec69023ae303"
    sha256 cellar: :any_skip_relocation, monterey:       "a44c2c7cbc4f59908f99fd9b1db39f7f8985e67c712ef5bfc2911ee68c0c5075"
    sha256 cellar: :any_skip_relocation, big_sur:        "54ee50777555e5566c3331113060be394e1c20c0b39400ee9e3508e57a191b0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "145f352362f8d1fe19ec60c98a55d92dd35bccc726dc4a8b8c3c7cf911f50444"
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
