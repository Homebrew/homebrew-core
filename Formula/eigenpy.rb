class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.7.4/eigenpy-2.7.4.tar.gz"
  sha256 "54f6f61f57b6588004725476b586318e62ae4ed456b81ed9ba262775e64556c3"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "383ad912e8cc7db8f1c126cc3b42621e71f54a45631c7ffdc6b315a133b4c340"
    sha256 cellar: :any,                 arm64_big_sur:  "ad2c9eb7d43512e2b6b6d0ec5166eee015d36d4c8519b43e25486a485da885a1"
    sha256 cellar: :any,                 monterey:       "0b837f40e2a68c3d572103e090ab36ec0cd8090b23b8350172920cfcd8b15deb"
    sha256 cellar: :any,                 big_sur:        "74dfd617bf76ea6e05204cc9e40dd4ea7efd9051ea9f9d0f049e13e5e6c5e431"
    sha256 cellar: :any,                 catalina:       "69cbccece577e7f566887a75323a54a9b12051601d6deada60e4bb317b25fdf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a79ea2824d6cd32d1681f7f7d2c3b33491154e42636724bfaed657cbd0ba963"
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
