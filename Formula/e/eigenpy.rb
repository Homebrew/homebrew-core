class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v3.6.0/eigenpy-3.6.0.tar.gz"
  sha256 "2c6784bb0cd9c58bfa6b22a29d5ec529537dc4496d8667740a62965ad2b5478f"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "04b6c5d11e2cc79ea25bf0b1e787e7fd2d8acb6148da403a1fcc52199bdddd1f"
    sha256 cellar: :any,                 arm64_ventura:  "b47fb889e0379648c62d51e7e9ebbbe7e8a40e522f0c899158bf158f3a609cb2"
    sha256 cellar: :any,                 arm64_monterey: "a19cd3f6735226a92e535a322423b8bc74275dc20c661fc04ce2cbb257a9cd14"
    sha256 cellar: :any,                 sonoma:         "de4928c1185d2d519e290b7166f81343c1940532f3ac17db119eece81bfe53d4"
    sha256 cellar: :any,                 ventura:        "15e83318c8bfbf80eecaa947aa8b2aeaf8229cc3f914ecf80b2d44891c542048"
    sha256 cellar: :any,                 monterey:       "82caeb916145c34a0e902a74adbf78c1a0b6bd21c114d5965aff5524fd70e1fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3643dff4c98b0103cec71e41387d01cfca777aa4122af9952dc849b7a34b25f"
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
