class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v3.12.0/eigenpy-3.12.0.tar.gz"
  sha256 "e6b7f17e1b7fb61e52447ceee8f47c3fc2c8f9cc4d19317e0467dc71babdb350"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fe47c8966619ea033382ed98d308ceb3e1b4cba455aa8eaefad6757535f1aaf0"
    sha256 cellar: :any,                 arm64_sonoma:  "cb823b98d099ed114ddadcf0847e5c8a00782f38789aff0003742a2cc430ba90"
    sha256 cellar: :any,                 arm64_ventura: "85db9eb13d2b7cf04a954e58a3190ce148a4c56d845c4afd6e6bf883ac81eb8a"
    sha256 cellar: :any,                 sonoma:        "7b5c71cc282e492fd54fb37b943232e0914e6f9b1faf5077de649a40cb74fd7f"
    sha256 cellar: :any,                 ventura:       "e21fe14654deca0d7a1466668b04c61b1e58fd4c25a8571863693adb384dcbdd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "565ce3df8071658b7a3a3ea62545e0028fcd2cb062d29db495ddf1de2ece7b41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3372b11b2d31eaafcee29f66e5d981eb3cdd5179a763111edba9ece9667e5647"
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
