class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.7.7/eigenpy-2.7.7.tar.gz"
  sha256 "461172077e348546f9a59b88471dc95f629f5cad9f56dc7f84fad46de82aad14"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d809f410de5a6a3b7309a7f477f559f404a21f9b6cf5371c2fc564169406800e"
    sha256 cellar: :any,                 arm64_big_sur:  "bf680c8392414e2f09f2777033c221e5d47d1461ba9863ab02edead9ebac0be5"
    sha256 cellar: :any,                 monterey:       "5d4f4bf70eda01edec925bb7e77a6b578c2657befe4b268639fea9a44b763b13"
    sha256 cellar: :any,                 big_sur:        "1b24d4224728fac932275b4910b29160f2dc6ebe0c266e31e5884e210726ee29"
    sha256 cellar: :any,                 catalina:       "fa04b54dd2757f9d46c95e536ebb9d91b7ad3dc60ac623a750910ec3024bf10d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b59fc55b3b62cdf447c83ee76964110ebf9ba04b49da857af9587de23154389a"
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
