class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.7.14/eigenpy-2.7.14.tar.gz"
  sha256 "b98157b78ef8db61e581bc432e44dd851627730626cd01c171e56c70da475ad9"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f5df19b454ae2dd9830f9c4ce3a20c9d9066d6a368ab82e6fd69636913520a05"
    sha256 cellar: :any,                 arm64_big_sur:  "a43cb0165cec4d79ffbfbf23e71444661e5110a0fac7f120f2bd3a77a3211830"
    sha256 cellar: :any,                 monterey:       "9fad56cee6622043f82aa6eb71ee6399497158db7bb8a05ba5aba255683ee96d"
    sha256 cellar: :any,                 big_sur:        "be0f45c13725c438d9e125fe3873422a2e7def7a1c3ba47aef3b7ad0808921d3"
    sha256 cellar: :any,                 catalina:       "02b56f5cb5b6137b779eef8e02728a72a3fa1fe084fd44fdb1780cf42b637835"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d11ec57b116f03a552a0183aea2fa3cab38024c261383f3d0f80cb2f8bb5b25"
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
