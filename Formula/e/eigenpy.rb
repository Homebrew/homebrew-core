class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v3.10.3/eigenpy-3.10.3.tar.gz"
  sha256 "ebfeef7a1974d9ef997a963d5e1b4500c0cbcfd6e2b5391176a8021624b3e126"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4de32b88bc5c86459f4b88f0ef51adc2cf4e2e9da5cc4fb15c98ee4c70ac83b8"
    sha256 cellar: :any,                 arm64_sonoma:  "c9fe663475ef0054e802fa4f0c0d131bbd080e0d8733c17f92bd0ff26c2ed9dc"
    sha256 cellar: :any,                 arm64_ventura: "35aa71a2586c8843adc2f10f8d2c81b23c28403ac7fd697a3c9f6613b538e003"
    sha256 cellar: :any,                 sonoma:        "691c155df4eab1c51eb590e83ac3413f15b487faf7fc62539526d238bd5a1707"
    sha256 cellar: :any,                 ventura:       "07a70a6b934f3196abd3d5bd58827fba9d6713444f9a45bc67b6c28f32382c77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45e5d0f9d6e785c806e1890912bd89a301f4080604c184ecf8b550abfa07a286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dfce78ea20c0e7274943478e974c7d364ee43ea6cc9532881ae38fb35045234"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build
  depends_on "boost-python3"
  depends_on "eigen"
  depends_on "numpy"
  depends_on "python@3.13"
  depends_on "scipy"

  def python3
    "python3.13"
  end

  def install
    ENV.prepend_path "PYTHONPATH", Formula["numpy"].opt_prefix/Language::Python.site_packages(python3)
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
