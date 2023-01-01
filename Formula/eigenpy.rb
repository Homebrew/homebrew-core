class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.8.1/eigenpy-2.8.1.tar.gz"
  sha256 "a96296a561a1f60b71fb89043ed0dc5fb8d048c70bae381100f59c42e83424d2"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7996f3f4ad17849dd0b4e3d8f9c54cd057e38dcabe22c4f7fc208bf0df4fbe57"
    sha256 cellar: :any,                 arm64_monterey: "d0ad359e5b7e96bf147680d766e045a5e1dd647aedc7a456bdba1b8db8160865"
    sha256 cellar: :any,                 arm64_big_sur:  "2b2b5f7dacea01b6c132a94033a02f88516731d98c1a3900938341acc628036a"
    sha256 cellar: :any,                 ventura:        "c5c08d4332102fc38f2c4918dc752f5dd2cf0a9474d5c311bb868ceddc109d05"
    sha256 cellar: :any,                 monterey:       "a5c07d694eba0af66ddfa7918a0caed4eebe96439154d16f8bc2a17b0493cabd"
    sha256 cellar: :any,                 big_sur:        "b7d122323ff1c517c5a7341141cc70ecaec1c6b1da522b7a72779d89eb4c2fbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c81a01d97f97709ba7dd6332bf2b54de43b66ecb7a68de5c7352ecddce3e2f29"
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
