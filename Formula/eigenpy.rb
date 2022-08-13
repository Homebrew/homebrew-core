class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.7.11/eigenpy-2.7.11.tar.gz"
  sha256 "cbd7ae9b4fd027afbcaeee5bf06aed02fad83a603bec90987c09b50dde2ce1e3"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ae3b4b1958521a69012289f81f054e285e9cd6cae6df4e3d83d25a275cefe325"
    sha256 cellar: :any,                 arm64_big_sur:  "9ae5d1a0ff58522652966b4209a7b95482eb1b9b90ec0c2df9a802c0d93199a6"
    sha256 cellar: :any,                 monterey:       "1bede84650cd002a8cd8eeabaee4d2f881526bee71eeca7dddb40247c4894ecb"
    sha256 cellar: :any,                 big_sur:        "b632c9720070adcf8b973312513e7996bd9a6987e0be80602d1db98ea6f6fc1b"
    sha256 cellar: :any,                 catalina:       "0d59a306150ec88c808047bcd4a0f6680aa325b58c462ab843e31839c1d65fef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5caf6266627ccf7ab66f7abbfa75cb99687e40cd28905211be91d26065f8b61"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost-python3"
  depends_on "eigen"
  depends_on "numpy"
  depends_on "python@3.10"

  def python3
    deps.map(&:to_formula)
        .find { |f| f.name.match?(/^python@\d\.\d+$/) }
        .opt_bin/"python3"
  end

  def install
    ENV.prepend_path "PYTHONPATH", Formula["numpy"].opt_prefix/Language::Python.site_packages(python3)
    ENV.prepend_path "Eigen3_DIR", Formula["eigen"].opt_share/"eigen3/cmake"

    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{python3}",
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
