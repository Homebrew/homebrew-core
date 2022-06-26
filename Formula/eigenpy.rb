class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.7.6/eigenpy-2.7.6.tar.gz"
  sha256 "71cc2763e891b7ef013b1c0306cdb7e497d6aff9f648dca30997e541b1a6e05a"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f4658808221bc42690502300246439c24f03ac0a516173d7237bc7095c40e124"
    sha256 cellar: :any,                 arm64_big_sur:  "f4b5abc044aab8ac6129c2a55e759f5194fca461037138fd41a7c007231983f3"
    sha256 cellar: :any,                 monterey:       "a4c7032a1a5770aa28685c8f09101aec4cba410734ca661782aec1191b0a1387"
    sha256 cellar: :any,                 big_sur:        "7a8da2f69ac4d0ea8db99de1ce2d4f54a1a671321b8c818992d32676772f5c21"
    sha256 cellar: :any,                 catalina:       "864bc6b6e7cfee2972299840f74e2527dfc9e4e77a60a815f5d51b28927c687f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad1b2f9b2b80f8d33a3306a1ac2e0dd1b107ac90401f28b44aeeb2c9afd6a9bf"
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
