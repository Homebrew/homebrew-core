class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v3.8.0/eigenpy-3.8.0.tar.gz"
  sha256 "81b8d6a44fe57c14cb4b99defd0621d862cf416fab70e1f77575446739c91e38"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "385b3f359310d6b30436ff208af414686c4c53d3c4028dc1933214136de01758"
    sha256 cellar: :any,                 arm64_ventura:  "e3f3c2e591767d4378dd7500eeb97fef5bf34a1773b2ae025eef5f1b256de812"
    sha256 cellar: :any,                 arm64_monterey: "3652654ebd0698be093eed183f08be202b63b1b7716b4a3b46b074af4f02f083"
    sha256 cellar: :any,                 sonoma:         "da21135cff267d546f9c16a2e200e3566f0247a826c596630e6514949b0cc875"
    sha256 cellar: :any,                 ventura:        "ab007085d3acecac684dd0cb5210d79d28480f8e659eeb7c591ff30ea5f70f79"
    sha256 cellar: :any,                 monterey:       "58e0e424a8c4c8bf77935c04a378482ff5525a9b1370c00c1b6db45ca317af57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76064a4c062f5dec430c0f6449d30bbb20db4d93e9259e1fb8d5c8949570dab8"
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
  depends_on "scipy"

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
