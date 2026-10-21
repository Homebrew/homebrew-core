class Qrupdate < Formula
  desc "Fast updates of QR and Cholesky decompositions"
  homepage "https://gitlab.mpi-magdeburg.mpg.de/koehlerm/qrupdate-ng"
  url "https://gitlab.mpi-magdeburg.mpg.de/koehlerm/qrupdate-ng/-/archive/v1.3.1/qrupdate-ng-v1.3.1.tar.bz2"
  sha256 "3877a52ff7bedd1edd746fed82f8347a8d1c4f48e59ebfbde7841eea79db87ee"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "20ae004b21fd7bdc2107a200d7f95330606f31d2fdd872dff653ffd28542850d"
    sha256 cellar: :any, arm64_tahoe:       "5494926f72245393fc03f80befab79cd4d7bd9c7b6c00eb54706c211c33c73b4"
    sha256 cellar: :any, arm64_sequoia:     "b61f3a3eea17f904797887cadb122bb00914ea64f6fac1657da312012c4d510d"
    sha256 cellar: :any, arm64_linux:       "bb413db2276e5ff87bd07947dc2aa3be901b74b9e45756167df572fcd315ebc2"
    sha256 cellar: :any, x86_64_linux:      "e2155413e91f6e08a2dc138e153dc0e0085483932e0d6eab3177731684b563f3"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "openblas"

  deny_network_access!

  def install
    ENV.fortran

    # CMake's Fortran/C interface probe requires matching GCC LTO versions.
    ENV.method("gcc-#{Formula["gcc"].version.major}").call if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "test/tch1dn.f90", "test/utils.f90"
  end

  test do
    system "gfortran", "-o", "test", pkgshare/"tch1dn.f90", pkgshare/"utils.f90",
                       "-fallow-argument-mismatch",
                       "-I#{include}/qrupdate",
                       "-L#{lib}", "-lqrupdate",
                       "-L#{formula_opt_lib("openblas")}", "-lopenblas"
    assert_match "PASSED   4     FAILED   0", shell_output("./test")
  end
end
