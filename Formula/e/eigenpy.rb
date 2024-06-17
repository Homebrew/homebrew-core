class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v3.7.0/eigenpy-3.7.0.tar.gz"
  sha256 "c88df6b44ccf8ac4cddc4c1015a3f1c3cbd7425cac1342f07ac16bc6f2b33f87"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1e2a15a1eb9e7f67e5eb0b9e3a6dedfe232ff0651960bf1bd2c6569b2326a1f4"
    sha256 cellar: :any,                 arm64_ventura:  "211d47aafa29cb172bad905cce813d11211d92c51a8cd8cfc28c2124fa3df533"
    sha256 cellar: :any,                 arm64_monterey: "f1721dc495fe389a8a9302e87563be8a44c3a2e19871a3b0539d311ee85f3b84"
    sha256 cellar: :any,                 sonoma:         "2fa5fa256a46421d45d6fb88f93f687fc182f3d5bb75fd09d4baa47dbcfaa692"
    sha256 cellar: :any,                 ventura:        "e68d5cc913fc0d7c5f6f9094b0c68fb03c0e7571702ed02d5efa91cff8b50008"
    sha256 cellar: :any,                 monterey:       "a30d62e9e3296fe241b6c053c90d7e179aa021e0fb867e4015fb310a90f29485"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "115860e2cf903adb7521ca11ce93c0b5facc3e09f7d9614d7b5778bdd8e5fef0"
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
