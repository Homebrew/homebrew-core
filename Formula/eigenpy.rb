class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.9.1/eigenpy-2.9.1.tar.gz"
  sha256 "b71928e23751e754d979b63ce1dfc567ed03faea3417b41aebdf9969d4f56dde"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "273bc721b695f7b2518922053bca9ef8c95759bcffc5229286eefc58b48da581"
    sha256 cellar: :any,                 arm64_monterey: "e30a5ab69908637b13d3f24d265f24a856692adc17bd566cf72ff1cfe6520692"
    sha256 cellar: :any,                 arm64_big_sur:  "37c113dc5ff9f070d0ede03fa8c66dfbbbf084d99c7e309e3484377ced51ca3c"
    sha256 cellar: :any,                 ventura:        "c48fdb901e21aaabbc5f86be9524fbf048d080024d9a05cd0ba3c048cff0e9af"
    sha256 cellar: :any,                 monterey:       "0533243123d104a618a04a7df2840d951e3214d384e160ff728b64c4ac8969f1"
    sha256 cellar: :any,                 big_sur:        "34c71576faf79182f61d4eee2074102e93df779e35c65a23bdb9116ee32007db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a99cefcbe092a0c7e6a03d44c18fbf0ffa5f49e0946dd7f2abed8e9dda3d2790"
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
