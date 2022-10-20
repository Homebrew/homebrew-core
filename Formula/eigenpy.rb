class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.7.14/eigenpy-2.7.14.tar.gz"
  sha256 "b98157b78ef8db61e581bc432e44dd851627730626cd01c171e56c70da475ad9"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d2219e4b3d2a9ad1541db60c4c3811d97aa87b20319b64009071fc49ff48c25c"
    sha256 cellar: :any,                 arm64_big_sur:  "f93087280d0afcb87a363f6676ae4341d7288aa6d1ac1b962e1f695edbd348aa"
    sha256 cellar: :any,                 monterey:       "02be878721c2e54936f425e9b42ac559a0994906233d60a034041fd212f1cda1"
    sha256 cellar: :any,                 big_sur:        "4ab33ed3dd5049c9b5b83b4550bd63b2c741bcf2f38f300fa1d4a11154b8cdd4"
    sha256 cellar: :any,                 catalina:       "ce3bba28d6dff39380d569fcc51a2f8e2db45dd1dbc14a6c73afdbb4e44921cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b99ac9d6d5a1ae23f9efee4f746efa413d5efc72cad334970ad17ca87879e1c0"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost-python3"
  depends_on "eigen"
  depends_on "numpy"
  depends_on "python@3.10"

  def python3
    deps.map(&:to_formula)
        .find { |f| f.name.match?(/^python@\d\.\d+$/) }
        .opt_libexec/"bin/python"
  end

  def install
    ENV.prepend_path "PYTHONPATH", Formula["numpy"].opt_prefix/Language::Python.site_packages(python3)
    ENV.prepend_path "Eigen3_DIR", Formula["eigen"].opt_share/"eigen3/cmake"

    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{python3}",
                    "-DBUILD_UNIT_TESTS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system python3, "-c", <<~EOS
      import numpy as np
      import eigenpy

      A = np.random.rand(10,10)
      A = 0.5*(A + A.T)
      ldlt = eigenpy.LDLT(A)
      L = ldlt.matrixL()
      D = ldlt.vectorD()
      P = ldlt.transpositionsP()

      assert eigenpy.is_approx(np.transpose(P).dot(L.dot(np.diag(D).dot(np.transpose(L).dot(P)))),A)
    EOS
  end
end
