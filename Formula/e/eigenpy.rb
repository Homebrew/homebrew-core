class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v3.13.0/eigenpy-3.13.0.tar.gz"
  sha256 "4e5f05ffa68a299732c6284348486d1f0c364e7f2a2bce0f14afa93780226d0b"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "devel"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f572d6cc00f87716dd9fec9d5c521b6dec79ad982965498c795f58e1ec78a169"
    sha256 cellar: :any, arm64_sequoia: "937f1be094388c96de9f2aa808206abcc98f7df0d93fb7f138f6898337d9df41"
    sha256 cellar: :any, arm64_sonoma:  "0e13052278ab3f0cda85a7cee031fe67c974d6f44b6892fccb37eccfada97069"
    sha256 cellar: :any, sonoma:        "109ac55e508ecbe608b7cbc87efc0db0ad92814c154f5a70fde80b6018540a7d"
    sha256 cellar: :any, arm64_linux:   "06a631b5f3926a6f9e9426d308549a73ebebc335e14ebdb6658bad495e04b020"
    sha256 cellar: :any, x86_64_linux:  "7fe4434412f7b4873928616a44653bb70085f1a4b7bd217c17d869c7d5625102"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build
  depends_on "boost-python3"
  depends_on "eigen"
  depends_on "numpy"
  depends_on "python@3.14"
  depends_on "scipy"

  def python3
    "python3.14"
  end

  def install
    ENV.prepend_path "PYTHONPATH", formula_opt_prefix("numpy")/Language::Python.site_packages(python3)
    ENV.prepend_path "Eigen3_DIR", Formula["eigen"].opt_share/"eigen3/cmake"

    args = %W[
      -DPYTHON_EXECUTABLE=#{which(python3)}
      -DBUILD_UNIT_TESTS=OFF
    ]
    # Avoid linkage to boost container and graph modules
    # Issue ref: https://github.com/boostorg/boost/issues/985
    args += %w[MODULE SHARED].map { |type| "-DCMAKE_#{type}_LINKER_FLAGS=-Wl,-dead_strip_dylibs" } if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system python3, "-c", <<~PYTHON
      import numpy as np
      import eigenpy

      A = np.random.rand(10,10)
      A = 0.5*(A + A.T)
      ldlt = eigenpy.LDLT(A)
      L = ldlt.matrixL()
      D = ldlt.vectorD()
      P = ldlt.transpositionsP()

      assert eigenpy.is_approx(np.transpose(P).dot(L.dot(np.diag(D).dot(np.transpose(L).dot(P)))),A)
    PYTHON
  end
end
