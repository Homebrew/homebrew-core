class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.7.13/eigenpy-2.7.13.tar.gz"
  sha256 "9260cb8d3b9e74692eeb14b549d9989ea4807cdfff50db211d80d33a0486c9bf"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b836c37b73928e0739d2bb508d8e8257cfd40112a2f01c0d2435c8de718c2ca9"
    sha256 cellar: :any,                 arm64_big_sur:  "fab89f1d26233d2c41b7b622aa139d24d612dd128e21667cb02a2b7027bb4cdc"
    sha256 cellar: :any,                 monterey:       "caeabd8205d0463bdc7d02d0849658ff5d044874b13a4abae993312f37d6e2c3"
    sha256 cellar: :any,                 big_sur:        "6a27e89462353044c3534ff5eb50bbffa3b194fe07bf34e5425f1c6b6038163f"
    sha256 cellar: :any,                 catalina:       "d55f44dc35c91d03a2754859b6d98e32d003d27751970fede6fe6cf4db88091b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4491a3f28c6c73bcc4bfc6a3ac790fc144312977304032a9ed97916bcdf4c408"
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
