class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.7.10/eigenpy-2.7.10.tar.gz"
  sha256 "f427c05f6daae05b9e898132c12aa5ef4c6541e841b9e65344cb4eab22371af0"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "434ac11a51c0d34b3c389a6f04de9e1676bc06e20f6a36f2cc8b0d440196c41f"
    sha256 cellar: :any,                 arm64_big_sur:  "fb571c1176d804b92306d49d0906b5bcf6ab675fccecc82f1a6c220a9008ecbd"
    sha256 cellar: :any,                 monterey:       "a48dd218e933cb5823a2fc976f6e5c52d91c13a7a816c9b9b17292cc06d5f6d6"
    sha256 cellar: :any,                 big_sur:        "fb8f0be994242316e776f89db386a100232741ad32bb3bc92080d676f5c0f4f9"
    sha256 cellar: :any,                 catalina:       "4208059f1439be2b85eee3960ffd4d2373c2d8ed0bfc6cd356577d4f415b9b7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "670001c4d097b24d2b4d07bc72d6046f221637ddacb6c069d17ca081497eea0b"
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
