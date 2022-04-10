class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.7.1/eigenpy-2.7.1.tar.gz"
  sha256 "00ccf08ce6e72859c5c91f703e4cb91ba724bace2338aa9f7c230d072ddbac19"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d72e0211246565d44859d0ea74e08b31a907af90654bedc03d28e031e3066b17"
    sha256 cellar: :any,                 arm64_big_sur:  "cf3e772ca33c5f15de1889157f9967c81ea93ee9be4916d3fd8ae86acd4dbdfa"
    sha256 cellar: :any,                 monterey:       "f74e50789593b49aad7b1c42352d3516ecfabda797ee2108b308a81e0a37a7dd"
    sha256 cellar: :any,                 big_sur:        "76f3299d8c9b9d00ccda3db868c8fa6842733cdc75d3ad30691be402895bd481"
    sha256 cellar: :any,                 catalina:       "7ea363976882d17328b39eab0645d47ef718da42cd004bc5ca852dc3a6c6a812"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c59f0d54929265e7a3ded8aea887998d574902524ceac339821559dfaaebd928"
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
