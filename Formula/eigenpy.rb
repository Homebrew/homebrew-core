class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.7.14/eigenpy-2.7.14.tar.gz"
  sha256 "b98157b78ef8db61e581bc432e44dd851627730626cd01c171e56c70da475ad9"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1d3b22288f17f9d08aa69ac0491f291ad387a052394b9c4b4e4f46489e8ae199"
    sha256 cellar: :any,                 arm64_monterey: "b70f2903680e7fc51501b6d549cb23291742b631bb2b392bd3c78334d22ed41b"
    sha256 cellar: :any,                 arm64_big_sur:  "9fe1e4b0754693d8bb9f6c5694f61ef4474ae6538b68c4f1bd0164f12290b95d"
    sha256 cellar: :any,                 ventura:        "243eeb09d5307f08bd058b39dfa9b914089786afb38596c7ef304c2f31fa07be"
    sha256 cellar: :any,                 monterey:       "4b85ad7f945da3353996b140ffb651704e12f2443b9fc47c7e24e58054629b8f"
    sha256 cellar: :any,                 big_sur:        "879eb117b19705638b2703a82ed550ee2bb01ecf98186760e5306769458fa412"
    sha256 cellar: :any,                 catalina:       "98dd5519903a7a9e3410d19b246f8e60df15807b7cf03558503f13a6ce687f01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce1d17804b013541595c2458d2d45b04d438fd9ee8a6b48b547523956ab5384a"
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
