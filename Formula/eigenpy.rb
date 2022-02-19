class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.6.10/eigenpy-2.6.10.tar.gz"
  sha256 "1ec1e166db0dddb8175d86c94697a41b387adf1c3a137827ff6ac35db6149880"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "cdca478f487e1ecf9844b26b570f388e9fa02e09ff1f0ca2d7409a1f1141630a"
    sha256 cellar: :any,                 arm64_big_sur:  "b0186c1842a53da60a26eb197dbce6bb968ba51b4c5a5ea60343702f7c344cf0"
    sha256 cellar: :any,                 monterey:       "02076ffff9f6ba73b061f7342aad2b43478fe6271f53cdb88871e19acd2f9c0b"
    sha256 cellar: :any,                 big_sur:        "6b1df9a474849ba4ffbd96b4d86beca581781e7f6aa2b73960aed0c1be4c9b76"
    sha256 cellar: :any,                 catalina:       "c7b264822bc659c40221558c90ed4e7c3da948d435c7a129db88bafad160ecd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bc5de1787442169f23e21e4810a3dd19a94017b0108fb8fe2a2ca09d27c86f7"
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
