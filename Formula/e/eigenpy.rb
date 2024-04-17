class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v3.5.0/eigenpy-3.5.0.tar.gz"
  sha256 "853a0612c341fd4e0136545e065f9e0d5e3177f62a00176a09667e2ffca66416"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9fdab7d5bf4d23fad641b2c550460669bcb0f4203fbfa5891fc38635f41f1733"
    sha256 cellar: :any,                 arm64_ventura:  "4aa818d1d3cad3cedcf4d3153223763c5260fd362b2576f67e1caa690e453cb3"
    sha256 cellar: :any,                 arm64_monterey: "b873e08137eef39bc79eb1a39a3babe8a2a545e55e3d0acf71e5fae1a3c7df06"
    sha256 cellar: :any,                 sonoma:         "99e3b8ae11d9e1b1442e837dd706fa3c0fa10b1fc660d95c370ba596251f3557"
    sha256 cellar: :any,                 ventura:        "f18698b012e1fae6e520299bfccc8b60d36d6602353518822c10a43533d157ce"
    sha256 cellar: :any,                 monterey:       "261d2956f84217751449383a62d6d5df8b5b220a3061f30abfb53b0e8222da67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd65dc03b0b8b361bca545483eace8b9661aedb6a810c8c2e06c70a9444e1079"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "boost-python3"
  depends_on "eigen"
  depends_on "numpy"
  depends_on "python@3.12"
  depends_on "scipy"

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
