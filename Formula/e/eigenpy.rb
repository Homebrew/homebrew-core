class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v3.11.0/eigenpy-3.11.0.tar.gz"
  sha256 "5c618843194cc372e1ba4e0430240f310985edd9fd7d99a7c24794d1b62e1b3d"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "eb4740eff258d271fa4b407aefd4b033b88d3f2a055d29b70c575c3d48ace7c7"
    sha256 cellar: :any,                 arm64_sonoma:  "fd2f68cff27af16c9b389841c70dc6649463ec95ca5bb8f208f512d61df03cff"
    sha256 cellar: :any,                 arm64_ventura: "dd713bb435a65899d6d2f738b6bac42e8b6f2d709dd28aa8c078a105d67deddc"
    sha256 cellar: :any,                 sonoma:        "8bec63d7e77382cf72a9476ab2d5d124423c2da2bdfed52374f6df66ec1bc823"
    sha256 cellar: :any,                 ventura:       "14b04868e217c005d03bf7666363b167e32f01fe15f6c4e3d59be4c047f17b42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d619ee61fae0f6b2301b715593320edf822856cdc77709df7a5e67bdf166486"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60b0f89902efccf9e266d8b915dcce2318ceee015bbe9e86671258bfc4aa8eba"
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
