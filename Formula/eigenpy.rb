class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.7.1/eigenpy-2.7.1.tar.gz"
  sha256 "00ccf08ce6e72859c5c91f703e4cb91ba724bace2338aa9f7c230d072ddbac19"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4b8060326909b1fe402e45e0846f4752f9edcef1eae6b4806dcd14706e02f6ad"
    sha256 cellar: :any,                 arm64_big_sur:  "121dd9086b4abe7bda835f8ef15e3016f6538d66e5e8786dc9072567cec85727"
    sha256 cellar: :any,                 monterey:       "0156b643134e5c21bf559382eb3100424ecadb5938d1e934427ac1663de2562e"
    sha256 cellar: :any,                 big_sur:        "44d97cbbe0947585be494348ff392b30034886679017bd72a205224400735c14"
    sha256 cellar: :any,                 catalina:       "5b4253d4d4b9cd4847f5fa7c59430581a27302d6934642447bb6c5d21e25d3db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c33beff4409c9e9845993cfd44e8c561cd27a68e86cf66958ac9a95617d89c27"
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
