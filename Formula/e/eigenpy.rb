class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v3.1.1/eigenpy-3.1.1.tar.gz"
  sha256 "3e2b2c3cd78f163f4d96bee008124ebe3369c6bab8db3c055c1cb239e49835b7"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f7139edb725de3665a189053fac0d9236b327412221917ed8d47f7d8e149c662"
    sha256 cellar: :any,                 arm64_monterey: "0405e981803d220215def0872f9320162c6b69b20077f348a52b7d089f56844f"
    sha256 cellar: :any,                 arm64_big_sur:  "4246053cefdb0c4992115d295f88ff0d3cf9c8f85938d0fa022ccaaeac511e35"
    sha256 cellar: :any,                 ventura:        "f5d27eb53296b48283b3f51c34f63e9962fa8e24dbdae2a08cbe67931a5dd408"
    sha256 cellar: :any,                 monterey:       "5f10517739d0bcf023a15242e2322cadabcc92f7f522c28dee4b47506de0661a"
    sha256 cellar: :any,                 big_sur:        "3603a2188e67ddb8398ba132a3b8957e1f789b81902a27fe90e7209d681e1b90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8065b3439a649c1eb87428aca5d851c0f16cda17d730e76e9a4e926456b7d9c9"
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
