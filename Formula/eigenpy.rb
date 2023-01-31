class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.9.1/eigenpy-2.9.1.tar.gz"
  sha256 "b71928e23751e754d979b63ce1dfc567ed03faea3417b41aebdf9969d4f56dde"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7c32ec6a51a34431ecdabfa0b66ff44eca5b8b8f2c8160baccfa26a7b15ed02d"
    sha256 cellar: :any,                 arm64_monterey: "e4ae4134acd95f4aa3650ccc6843bfbadc49949ec8c2453cca150bde92d5cd3e"
    sha256 cellar: :any,                 arm64_big_sur:  "bafa0f4e1c4e809a5109bf9c722a6dda9eb19b96b6ca94788eb86485042c465a"
    sha256 cellar: :any,                 ventura:        "9fd9cec48ab3afa216dabe84a3bcd579f8ca82a16e1e07f73aa939128d53f180"
    sha256 cellar: :any,                 monterey:       "5452127886126201a8461dfd40b15cf1831cb2c8ffd23387b3f26b860847cfa5"
    sha256 cellar: :any,                 big_sur:        "091aa57bfe29f67ef98a51c597a6e157c3a14985a141c9d9d620e870ec244eb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f54250863fd447ec941e66cfccd5a156dd8b5c4b2a8af41060c0c010c206440c"
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
