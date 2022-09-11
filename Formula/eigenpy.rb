class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.7.14/eigenpy-2.7.14.tar.gz"
  sha256 "b98157b78ef8db61e581bc432e44dd851627730626cd01c171e56c70da475ad9"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fc524059757cd7b5ebb705ae2dab783efd59c7bee8f100ddc00a0fae3ef40e1c"
    sha256 cellar: :any,                 arm64_big_sur:  "f31be04fb5004a55be111c39d8b3d33c4a85b6f37af729e68f8a46ef97c62257"
    sha256 cellar: :any,                 monterey:       "5185731f455073083ed12ceaec81cbe00657190567bd27c5e603a1ff5588e0e1"
    sha256 cellar: :any,                 big_sur:        "005f3b4a9736aa8a8b624bc05279f5767e1a96695fad79a5a1c6a61978f80419"
    sha256 cellar: :any,                 catalina:       "732fdcfd13de9cab35fe2802737c809dde7b221935dffbebf7e9974b79660e45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53f2785dacdadddbbd37f8c7e43e539000adddf556eadd89a3860f0d4783cf20"
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
