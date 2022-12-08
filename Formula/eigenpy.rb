class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.8.1/eigenpy-2.8.1.tar.gz"
  sha256 "a96296a561a1f60b71fb89043ed0dc5fb8d048c70bae381100f59c42e83424d2"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "84bd931569206e95af68723b48bc7b91b8e6dcc3a7112ca1bcb67246dc1a3495"
    sha256 cellar: :any,                 arm64_monterey: "d0a47e73270d0620276af04027ed549c44a7643e4a79bfad36e8c6840ec8f86a"
    sha256 cellar: :any,                 arm64_big_sur:  "6875911257c3819f03ccc0ca0c55d578e2102a69d8127cf859b8f3081b93ec9c"
    sha256 cellar: :any,                 ventura:        "e7d3866b0d1c3140a295cacc16f9414a23ef97442ef818091d66bc4693f0d08c"
    sha256 cellar: :any,                 monterey:       "c26891ea205535ea8615dfc9d991997f85005a8b877d46c99fc3877368aab970"
    sha256 cellar: :any,                 big_sur:        "51998139bdae8f3eda467cf93e55760fd8b8424e86d8b0baf94e2b1f88c6de31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "791f62a9d1c1c87676d63888330ff0c496a71b9c1a0a87a2b52ce07e234ff9c1"
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
