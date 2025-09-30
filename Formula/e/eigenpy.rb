class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v3.12.0/eigenpy-3.12.0.tar.gz"
  sha256 "e6b7f17e1b7fb61e52447ceee8f47c3fc2c8f9cc4d19317e0467dc71babdb350"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1d1d547cc93d444c8fdd9a20e9fb23af6ddfd165b956d7dce9b0f594cdb1f468"
    sha256 cellar: :any,                 arm64_sequoia: "cca3b9d1285cd8704ca2668de6b6f4a3778a91b536057dc45111502f60dfe605"
    sha256 cellar: :any,                 arm64_sonoma:  "45610bba26ba4392968abe833dd94bdc1c70a1e2c394f8bb0be3b610be505a1c"
    sha256 cellar: :any,                 arm64_ventura: "94bc40811f276f1c53bd0b96d69700a5de51f7623709038870dbd11bf5ae3201"
    sha256 cellar: :any,                 sonoma:        "9cf1a7620763bdae38911d325024e1f1035dbbaba4ea9a1ecfe0cf61c5006106"
    sha256 cellar: :any,                 ventura:       "aa01446a0c86af65c48797735b6ec8a6d15483b911a4bbb7799bf083dc83cbff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04cb2ef9621bbf348081f398073e6b2cbbf02b2941d1ff96caabf86370bc1c4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dde526e9c10cbf4c43c9baf396277ce769aa6a6703b03b02ddf41d9e1e40231"
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
