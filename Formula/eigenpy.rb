class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.9.0/eigenpy-2.9.0.tar.gz"
  sha256 "46af67c092554c048b1785b2c3dbdbf6b9e0c7f7de54c76bb057bdd3550fe8e7"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d81ea227306a4f7bdd4fe023b036ff01e31beedabbb0aa431b077b3655819b6f"
    sha256 cellar: :any,                 arm64_monterey: "c2482f8dd15815ed2eb91f931cd8d5afb4f079c2395b2d937f326122f3c78058"
    sha256 cellar: :any,                 arm64_big_sur:  "dfbac8d971ea64c1ddfa43706e6a99ff811128e8a5336378f1de295d483328cf"
    sha256 cellar: :any,                 ventura:        "8a4ae3bc233914428819a981790c773311ce96068c6d2cc383990f235263c86f"
    sha256 cellar: :any,                 monterey:       "bb863439151839a1859f0eebfa4bea2cd4f54a2d4dd7771a60906050d1e975df"
    sha256 cellar: :any,                 big_sur:        "2b777696011c7f62bc1c9f53be50c871d5aac35eb4004d4a99c915695f78dd08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac099f270199a65bbaae0dea34a74932e2cf055027224a7de1a1779b391aaca6"
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
