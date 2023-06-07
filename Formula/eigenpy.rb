class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v3.1.0/eigenpy-3.1.0.tar.gz"
  sha256 "3b2faf13a96d875764c3455e8c722288f49472dbadbe86bca5fa815bb8617f7a"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2707ce11086d5e48fef989ebb31e89b20ca71442c737d414c547f2661085c999"
    sha256 cellar: :any,                 arm64_monterey: "db47f015e1dcb3e5b7c5167b34a2d06f06d6c794ef5b743b778dc3b7b9a52f7b"
    sha256 cellar: :any,                 arm64_big_sur:  "20194269876031139c926cc3a12bd383e50b6ffd0b7e1416a105aee7be66f441"
    sha256 cellar: :any,                 ventura:        "0a05f83ed798165383b8c0cc8b655c3fd683bd3469ffa9f65526fac47aaa61bf"
    sha256 cellar: :any,                 monterey:       "62148a71755b9259b1adff2c1e7556c23caccc092ad7a6627c02f9f8d3d86e2d"
    sha256 cellar: :any,                 big_sur:        "de63abf0562ef833c94a951dc4e7eeb231ef6903658c419d8fd591c47174fd93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5920f6beda62c6ab961c7b2783569721b3f7a938d75bf22748a21bba753241a"
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
