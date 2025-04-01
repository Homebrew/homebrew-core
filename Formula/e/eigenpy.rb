class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v3.10.3/eigenpy-3.10.3.tar.gz"
  sha256 "ebfeef7a1974d9ef997a963d5e1b4500c0cbcfd6e2b5391176a8021624b3e126"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "b82abe0f7777ac483a834270cb6e440b5ee0e02d6b6d79b3e1fabd5be153b66e"
    sha256 cellar: :any,                 arm64_sonoma:  "9dea42502d4283aedd3c2e5d4fe9c54b657399549d7ddac2ec6a3cfb8b78e037"
    sha256 cellar: :any,                 arm64_ventura: "6a95ce53e270f94576dc95ed61e5fe8531ccf24b6baaf5d31377bcb2e6653f23"
    sha256 cellar: :any,                 sonoma:        "126e7a7b9a76b036717ce3f446dcf01e1af56ebc3e736c2976d0ac19e9674c6e"
    sha256 cellar: :any,                 ventura:       "f5f0714168a5a98d65b9e945fa7a954082e1286d6bf0454c2ae59e7f0ce0be83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "707c3c98c576cba0636ed9324d2d4b7597873c4d0f916ba8208b03396f08e023"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8da8406a32c0300e587be9f725b87fa8fae7d6ec66665a77d00b6653ebc9261a"
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
