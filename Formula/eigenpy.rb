class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.6.7/eigenpy-2.6.7.tar.gz"
  sha256 "75b80c7a29453131c692cb55f652e4f45da6a5d0a522d04f71862baeb029a924"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "ec78a5c880d9a0d009fbca8c85577a28c7da6500624183ffdf67a6d02de8757a"
    sha256 cellar: :any,                 big_sur:       "9ab8e65c15d034579a20f06d7daf3c78c932e68b3a61e377c5f62e78c76021b2"
    sha256 cellar: :any,                 catalina:      "82d0dae974ebd520801a7ee40d2ad82059ab713a4adb38b15da7a06c488c2cb9"
    sha256 cellar: :any,                 mojave:        "442ff6eb6f5d551f083be28b23511ebf661b9a4ee4ea0f3e364634e8ed731aa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c833378b523165dc2a9ae65e66288fdd3a9ec56c02d6f5c366a9a10ff1b2bb3a"
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
