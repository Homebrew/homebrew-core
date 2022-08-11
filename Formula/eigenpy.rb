class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.7.11/eigenpy-2.7.11.tar.gz"
  sha256 "cbd7ae9b4fd027afbcaeee5bf06aed02fad83a603bec90987c09b50dde2ce1e3"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1fac4a7078d6629201cf864c5144fd37d0b98a7020c1cd102c95d5a7e8dfcb33"
    sha256 cellar: :any,                 arm64_big_sur:  "7428a07c06b2166740522dd25402e488d30defde04db0bbd91c7473e85b158aa"
    sha256 cellar: :any,                 monterey:       "af26e5e2c894353b9639f995152cbdad52f7fa2c850f7df5103e1aa372968f43"
    sha256 cellar: :any,                 big_sur:        "ed8d1316508e0c32b060a3208c3e6fe479150c0efb70976625e1faca642d24c3"
    sha256 cellar: :any,                 catalina:       "1c340ab63e35532373ea6f5cce33cbe8e0a3777f438d3e38f555583fa8f025b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56bacb98f5cd33a3596f2bbc062b2a1f4bca15c1139c57b4dfcd1a1af24966bb"
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
        .opt_bin/"python3"
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
