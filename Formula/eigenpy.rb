class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.6.9/eigenpy-2.6.9.tar.gz"
  sha256 "fa73023f30e3ad341fddbd984e22260fdae5a84656e08d7dbf0045c909fdf9a7"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "1bc55f1d1204c796c907e83a4d3a879386332047a10562ab511302be825ccdec"
    sha256 cellar: :any,                 monterey:      "33a468df036e701063635d80317d8377c2b6764fc835ee42f6b2b19ced73e785"
    sha256 cellar: :any,                 big_sur:       "cd6488d937b6767a37cab99b4672ff01620c6179083e2edcbf8c2068a0e89bd7"
    sha256 cellar: :any,                 catalina:      "1f638c3ed39e9861039f919c168fd78a124d0b67952da7e9ad3deec576cb6587"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34dab627a99e3a2da59e87d17da5990feb047f6c55eb7ac83bc9501a604f5b62"
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
