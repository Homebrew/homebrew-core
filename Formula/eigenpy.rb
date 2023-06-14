class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v3.1.0/eigenpy-3.1.0.tar.gz"
  sha256 "3b2faf13a96d875764c3455e8c722288f49472dbadbe86bca5fa815bb8617f7a"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c82fd05930316ba54316c33f450054ed47343c973c644d4d7e551d91ccee8528"
    sha256 cellar: :any,                 arm64_monterey: "d563903d954481eff8269e043ef28ce7824948a82ff3aca41bcc3b400876635f"
    sha256 cellar: :any,                 arm64_big_sur:  "77ed8242928775b6af9115bbcc3e9bd3bd25c7844e279f9618ae2dcc65324c06"
    sha256 cellar: :any,                 ventura:        "807a79528f2561482d62e899a5e21b6991c7ffc74d4c8f0f5dc33e96423d666d"
    sha256 cellar: :any,                 monterey:       "1c8bd9bc31c41e01a745f982232863fce3db45118de812339b556f772405d5e3"
    sha256 cellar: :any,                 big_sur:        "07bc7a800422a44d78286babe0a0a81e970a0db2b6c408d14eaab9e01b0934d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "005c80ab87d07d1ab3644f451994d94ab8da7ff6b19c15375d87d63c7da0afea"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost-python3"
  depends_on "eigen"
  depends_on "numpy"
  depends_on "python@3.11"

  def python3
    "python3.11"
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
