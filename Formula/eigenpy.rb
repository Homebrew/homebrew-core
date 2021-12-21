class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.6.10/eigenpy-2.6.10.tar.gz"
  sha256 "1ec1e166db0dddb8175d86c94697a41b387adf1c3a137827ff6ac35db6149880"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "788b13fe2bb3a5c16ccc31d2f08db9e922ee132c7f3cb79eda6c6964df9569ce"
    sha256 cellar: :any,                 arm64_big_sur:  "761b59d40dec36c913826cd5eca4a8a855409d5b4bc6aead009211c8d638cd80"
    sha256 cellar: :any,                 monterey:       "f5660a359a4c8568ca72d903f8f7ac2fbee08e3adbd9e82d925dd0cefa397dad"
    sha256 cellar: :any,                 big_sur:        "434939efe5d0a653f3c2a3c5ee5b7b8774e513ae97a406c402c2417facd0d63d"
    sha256 cellar: :any,                 catalina:       "2596920032ac5649fe1349f002f59bf264cfd25d6f1d8ddf3b21a92af2db6430"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b6a93ca7b23558ecf2b4052eb52b4e8c276dacd430efc82c8edbb6c4cb040b7"
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
