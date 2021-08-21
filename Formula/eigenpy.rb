class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.6.7/eigenpy-2.6.7.tar.gz"
  sha256 "75b80c7a29453131c692cb55f652e4f45da6a5d0a522d04f71862baeb029a924"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "5ee7af3416f232054d7d61d7eee5dcc88f9509ee8a4ee6cf57b6d65168ea946a"
    sha256 cellar: :any,                 big_sur:       "2d5bcf43cd305a92f65b8d9dd4c9432f2cfa249960908c6115fcd57683ff574c"
    sha256 cellar: :any,                 catalina:      "9ba406c84f100ddb18f6a5951ee263880401cbdb64cc5cdf9d3f8359c9b00d0b"
    sha256 cellar: :any,                 mojave:        "ebe97ff91b4b3797931b9e8ba3c0455f67989a97aeb9fcf397553bb6cb60ca8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58aa0e6cacbc2d23603ac33209b7e506c74759939203c5107d1a05b174c55f2e"
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
