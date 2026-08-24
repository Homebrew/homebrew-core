class Qrupdate < Formula
  desc "Fast updates of QR and Cholesky decompositions"
  homepage "https://gitlab.mpi-magdeburg.mpg.de/koehlerm/qrupdate-ng"
  url "https://gitlab.mpi-magdeburg.mpg.de/koehlerm/qrupdate-ng/-/archive/v1.2.0/qrupdate-ng-v1.2.0.tar.bz2"
  sha256 "d3bea4ceafd7b1641ca74c50b74060aeacd7a3cb9ff4159a92aad9c262c57666"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5f3b00d4d1cdb79a375186561384a729ce693b4318dcc03fa54478abf784c752"
    sha256 cellar: :any, arm64_sequoia: "7fb2fd0aeb930f13a44003cb94c5a3891be1f9b2c333910487e7cec152fd853b"
    sha256 cellar: :any, arm64_sonoma:  "184388b19a09bbaf9f821e0bc8fee0be683e596cb47b7c04ed63274b55ef9ed7"
    sha256 cellar: :any, sonoma:        "7669fd92b4f180606f4ead7616796b940cde94c2c0df702719f826a362be6e05"
    sha256 cellar: :any, arm64_linux:   "5f5f98be5978fb903010c7d4f49db25d81f761fc538bd6b2bd5f4c661488dd30"
    sha256 cellar: :any, x86_64_linux:  "884b9617d497624bb800650b596a2c9abfeac02c7a95f33af950d84783195232"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "openblas"

  def install
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
