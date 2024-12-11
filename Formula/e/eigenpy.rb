class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v3.10.1/eigenpy-3.10.1.tar.gz"
  sha256 "7b4ea31c8eda2eeba6b1ebb22ebfe72b650e04da20e6ef48d48008c2afb1bbc4"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2873eb6f51db6437e0a463de495856c3c36a95157be2cefaf77923be054b2ac1"
    sha256 cellar: :any,                 arm64_sonoma:  "178b9c4635958edd26edc9fc3d3f496f77d1425cb2cc0d87bc3f7d8805069844"
    sha256 cellar: :any,                 arm64_ventura: "9a83b7ebdb25767c84adc267701182830f5f5ad85d20ad1b0abe09138f3e2890"
    sha256 cellar: :any,                 sonoma:        "8405f62554a5deb4c51c1a751a5eda8797418c4dcdfcf909bcc005607c442b37"
    sha256 cellar: :any,                 ventura:       "b5c5be71db3f9252241280ab376645a4656c9b67e9449d42fddcea3b63078194"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96fb6f25e75ddcc3f05d1a6aaa229d5a9450f5ad32b28c24c8db28d7d946307a"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build
  depends_on "boost-python3"
  depends_on "eigen"
  depends_on "numpy"
  depends_on "python@3.12"
  depends_on "scipy"

  on_macos do
    depends_on "boost"
  end

  def python3
    "python3.12"
  end

  def install
    ENV.prepend_path "PYTHONPATH", Formula["numpy"].opt_prefix/Language::Python.site_packages(python3)
    ENV.prepend_path "Eigen3_DIR", Formula["eigen"].opt_share/"eigen3/cmake"

    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
                    "-DBUILD_UNIT_TESTS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system python3, "-c", <<~PYTHON
      import numpy as np
      import eigenpy

      A = np.random.rand(10,10)
      A = 0.5*(A + A.T)
      ldlt = eigenpy.LDLT(A)
      L = ldlt.matrixL()
      D = ldlt.vectorD()
      P = ldlt.transpositionsP()

      assert eigenpy.is_approx(np.transpose(P).dot(L.dot(np.diag(D).dot(np.transpose(L).dot(P)))),A)
    PYTHON
  end
end
