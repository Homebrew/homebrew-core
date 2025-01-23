class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v3.10.2/eigenpy-3.10.2.tar.gz"
  sha256 "1b24316e01e9d1d8f90baca838f9d9996608b0390df13491900e92ca59801db2"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7b1c80e4e35b2419e37cfd55810c6444b07e7c9f1e1ec3945714877510ea798f"
    sha256 cellar: :any,                 arm64_sonoma:  "1cdabe8130bc9fdb3111ef96e6ce4fc5a80540292c120c38fa300438ab865f62"
    sha256 cellar: :any,                 arm64_ventura: "0a9d0f66de5873508cc453245dbbd2de36d48ef21d0da7086c2a20b2f9fc3803"
    sha256 cellar: :any,                 sonoma:        "fdb90712a032b9adce501560265b02a4dcaf1c6cec0dbef9d83d7b315901ecca"
    sha256 cellar: :any,                 ventura:       "88b3288690a7870c907fbe2bad7f74186c14942db64be3345edc497153bcfae7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98c8b561869cb36088ce2a1e6eb2393bcf5a49e8d47b38b739e701fee17eca61"
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

    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
                    "-DBUILD_UNIT_TESTS=OFF",
                    *std_cmake_args
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
