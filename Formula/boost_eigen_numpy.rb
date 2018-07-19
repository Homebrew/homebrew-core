class BoostEigenNumpy < Formula
  desc "Boost.Python bindings that convert between NumPy and Eigen"
  homepage "https://github.com/personalrobotics/Boost.NumPy_Eigen/"
  url "https://github.com/personalrobotics/Boost.NumPy_Eigen/archive/v0.0.5.tar.gz"
  sha256 "ccfd02fd91e80ae918fb3d6ae98d60586894138ed1f9c3e3189cc1783639d51b"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "eigen"
  depends_on "numpy"

  needs :cxx11

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system python, "-c", "import boost_eigen_numpy"
  end
end
