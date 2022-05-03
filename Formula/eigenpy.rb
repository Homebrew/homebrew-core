class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.7.3/eigenpy-2.7.3.tar.gz"
  sha256 "0a205e10ed9490e4ee7f3fdf6749fff0636a7648ed72bfbba3569986a8ee2b58"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0fa97394741631eda7e52be7e09ae77879c26738aadf0fc4efd825fc53b12465"
    sha256 cellar: :any,                 arm64_big_sur:  "77809276277e83aea77aa57d01e8f3266a847659d003c2fdae55965ab01417c2"
    sha256 cellar: :any,                 monterey:       "099648c0e7751abae84e575a2002ab8168d15cb0911639b64d989d3f7ef5e103"
    sha256 cellar: :any,                 big_sur:        "0d011347567a7f994ac5109adb0035ff6a75b7cf366a2707e80b472f617c5e1f"
    sha256 cellar: :any,                 catalina:       "0fd0ef280f46d247d2c4233c309603c03ce640cfc3718b13a4b790b21da37171"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7eafd8ec8efc80407a2ea4bdc6564a791ef6cb887d0d4075ae2a42782ae2823"
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
