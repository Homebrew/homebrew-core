class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v3.3.0/eigenpy-3.3.0.tar.gz"
  sha256 "ecfab9fe7a6a37c64c80c4ebac102ed5f072e95f696d3e9a918a8db8fc35b080"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dcc0a5e68625e5f7b314ff09070561649418768c3e1d457e438215315b707bf6"
    sha256 cellar: :any,                 arm64_ventura:  "384adc586fae8d3dd7d5618e8aee4d0f7daeb1fb66315e2afa3524cdb474c057"
    sha256 cellar: :any,                 arm64_monterey: "e7839713f4a4c192252005895d011e85b8993870d05cd582aaf3ab302b12c1d2"
    sha256 cellar: :any,                 sonoma:         "f1ab863bb60db0eaa7e4883d727db7b168894d7f0d8da35274dfecc3d087654f"
    sha256 cellar: :any,                 ventura:        "59cc18eea924df5fe2b66311e5c34e477dc7a7ba0e137403148a3a3fe452de94"
    sha256 cellar: :any,                 monterey:       "88d78df7e492a839e75437a21a5774cd3cd13b5df59c8591b23f47ea0e1b7f43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d40452eeb9196541a79a6a83bba0802610f23c68e6ff7afe5c4f6ca1639b77ec"
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
