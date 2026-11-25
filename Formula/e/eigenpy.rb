class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "4cdd66deb0002506ad38502b11db0f49510170e36d29f06b3252c8a731b4dc4e"
  license "BSD-2-Clause"
  compatibility_version 1
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "devel"

  bottle do
    manifest_sha256 "e458340e0b89dd1cd191009ffa7608fac565c5fdfd24a7913007313df63c0510"
    sha256 cellar: :any, arm64_golden_gate: "50e656ffc3c683f51c76ffd8c0078687dda1c3f2b0464d8af115fd607656e41a"
    sha256 cellar: :any, arm64_tahoe:       "026c9ea4e0d6240a03d579a75f2350851268f9d982aa86bd16fe2ccfba52e486"
    sha256 cellar: :any, arm64_sequoia:     "4d3310fccbbf81a96822680ea39789c2cb743067661a0deef9839c8f094ab0a9"
    sha256 cellar: :any, arm64_linux:       "0a319310197cbb87b9b875291501c658b1d088f7ea26c58a72c127586f6ce6ed"
    sha256 cellar: :any, x86_64_linux:      "08cc4a1c93643717dfeb2e8fdc7eec87acde5096de06bd8af3218fa4f35a942a"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build
  depends_on "boost-python3"
  depends_on "eigen"
  depends_on "numpy"
  depends_on "python@3.15"
  depends_on "scipy"

  resource "jrl-cmakemodules" do
    url "https://github.com/jrl-umi3218/jrl-cmakemodules/archive/refs/tags/v2.4.0.tar.gz"
    sha256 "1e810d43d471e9a172458187fd5ec0746d3155e173f4fb387e6c7fb56906d359"

    livecheck do
      url :url
    end
  end

  deny_network_access!

  def install
    resource("jrl-cmakemodules").stage buildpath/"jrl-cmakemodules"

    ENV.prepend_path "PYTHONPATH", formula_opt_prefix("numpy")/Language::Python.site_packages(python3)
    ENV.prepend_path "Eigen3_DIR", Formula["eigen"].opt_share/"eigen3/cmake"

    args = %W[
      -DPYTHON_EXECUTABLE=#{python3}
      -DBUILD_UNIT_TESTS=OFF
      -DJRL_CMAKEMODULES_SOURCE_DIR=#{buildpath}/jrl-cmakemodules
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
