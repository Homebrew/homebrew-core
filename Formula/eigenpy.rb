class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.9.2/eigenpy-2.9.2.tar.gz"
  sha256 "a8b64e6db34282bad7b5006512ce506ef148c445a337abdbac7fc2caf22880e4"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3fadb6f61ff2d7aa5aa4bf236bf2012cb4b7ee04cb242b247e2e078c5d36ba8a"
    sha256 cellar: :any,                 arm64_monterey: "077d7f1389a95bebaf7957a8cbcf07aab08caedd167194a2bc740f797bca1042"
    sha256 cellar: :any,                 arm64_big_sur:  "6be277fe0e8f4345b4bbee056bfd0b8985704761a618336856c1b5a0197e294c"
    sha256 cellar: :any,                 ventura:        "c9c7bedcc479f6b32e419f176d847b42807fbae00693c189516039659eaadaaa"
    sha256 cellar: :any,                 monterey:       "f6b46b6342d83561cfc809e668f25664946306e1e42c9d2b0ee85c10f2799ad3"
    sha256 cellar: :any,                 big_sur:        "6d8fa6ada3bdfeb60e4296f973cd67f85c54178617ee4a273dd7e70528ad7a44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ddd43ab25cbdae77416fe62350229c8925f27ce88b405db492ae7fbd71313e4"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost-python3"
  depends_on "eigen"
  depends_on "numpy"
  depends_on "python@3.11"

  def python3
    "python3.11"
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
