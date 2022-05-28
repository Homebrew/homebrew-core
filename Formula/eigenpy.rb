class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.7.6/eigenpy-2.7.6.tar.gz"
  sha256 "71cc2763e891b7ef013b1c0306cdb7e497d6aff9f648dca30997e541b1a6e05a"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "70ababee9d98857b3e942a0f4d6ff4d62bf4597a93510f738ce8d9494ad49032"
    sha256 cellar: :any,                 arm64_big_sur:  "e97827139b27ce7126d29f70cc20aa6aa48357d3a241c30be402c910df784c29"
    sha256 cellar: :any,                 monterey:       "0db37180220dddab9243d7587a65db650b90579ac8937f9398613c8e02759bcf"
    sha256 cellar: :any,                 big_sur:        "9efcc97d2ef1974c15d26ee62402b2f767b52b859a54907199466ef5cc9227ab"
    sha256 cellar: :any,                 catalina:       "a4022e9b4c8d19019fb8e2fcd464c59f5b88034b737c24c747a9d426efc89719"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ae4dcb64e5bce49e63a7aa7cd0f2313c1c8d8768249fbc38d8fdf92eeb2846e"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost-python3"
  depends_on "eigen"
  depends_on "numpy"
  depends_on "python@3.9"

  def install
    pyver = Language::Python.major_minor_version "python3"
    python = Formula["python@#{pyver}"].opt_bin/"python#{pyver}"
    ENV.prepend_path "PYTHONPATH", Formula["numpy"].opt_prefix/Language::Python.site_packages("python3")
    ENV.prepend_path "Eigen3_DIR", Formula["eigen"].opt_share/"eigen3/cmake"

    mkdir "build" do
      args = *std_cmake_args
      args << "-DPYTHON_EXECUTABLE=#{python}"
      args << "-DBUILD_UNIT_TESTS=OFF"
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system Formula["python@3.9"].opt_bin/"python3", "-c", <<~EOS
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
