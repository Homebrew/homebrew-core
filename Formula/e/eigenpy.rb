class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v3.2.0/eigenpy-3.2.0.tar.gz"
  sha256 "1c7679e11873a30bc8efbf2a8785a2f000670c10c42751d0d99bf3f1e0b2dcd3"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c75579891671690e92382c34c4956d76f136675ac51a05f1082f9154b8d12fd7"
    sha256 cellar: :any,                 arm64_ventura:  "3382f515ab9bab805c99c9995c6a7e89b1672c02f5aaf30f87f453d66ceb42ed"
    sha256 cellar: :any,                 arm64_monterey: "7eec350a62e622294a8994a0430ff1821e087556d0d391d2f0b156f01d9fcefb"
    sha256 cellar: :any,                 sonoma:         "14d1e19dc03cec43ccef8d5decf0c5a25e928d7d9e901cc93b08c256d2771f55"
    sha256 cellar: :any,                 ventura:        "d800650e3240b6d024f1b9028c06830a9f39339559a1363280547e0cfb7e0e85"
    sha256 cellar: :any,                 monterey:       "dec23c9a1311ebaa4feb8a6590193ee1cc6e7dab3e4198f75e3de8caeb0c1d24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7335b2b7612f0f242e02d12596401495ebe5bbad9113169ab5e247c3b727204e"
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
