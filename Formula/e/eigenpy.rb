class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v3.13.0/eigenpy-3.13.0.tar.gz"
  sha256 "4e5f05ffa68a299732c6284348486d1f0c364e7f2a2bce0f14afa93780226d0b"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "devel"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "48bd2451228e042a5bd892fdbc53bccdadb0f8ba07450a91400c476b3550f10a"
    sha256 cellar: :any,                 arm64_sequoia: "a154b4025c58b9da0de3a89d5d8e1cf7f17bab21476acc852bcb8d54bbcd70c9"
    sha256 cellar: :any,                 arm64_sonoma:  "c8939ec903ba742601902ead8aed1d53d2c9fdfea85d0bedc601b8220de78431"
    sha256 cellar: :any,                 sonoma:        "8ca4115390815304ad72a0e667cf6c531f39dbb7030ebf497ce7db60b2a2491c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42a2ec2983cb10818c57217afa622d347e4233acac191fa5a730b013e1191402"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b35b3c9b3546bd52ff0947d7f2f6b1f6bc769605dbb8456b374303444e08f46"
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
