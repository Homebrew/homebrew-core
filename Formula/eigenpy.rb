class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.6.8/eigenpy-2.6.8.tar.gz"
  sha256 "4689c4ff90ad653482c8fd2b8a798994fc50cf982703252b9acc18cfa11cb59e"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "eb11190417c96a928c5e6bafdcf631d6ce5bade0c502daab66e02aaef8203dcd"
    sha256 cellar: :any,                 big_sur:       "6772ede3f8185fdb42833688d971407c54c0d69e78d1962b491ff1c7078cb150"
    sha256 cellar: :any,                 catalina:      "88a10f6d708d135b5df4d59ed5248391105446c7ddf10850fbd911c65c68d82c"
    sha256 cellar: :any,                 mojave:        "653d9c3e87e3a73dd0f6192196656c1f09a15710a3630f19816a2db5926cd7f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1630ea5636136747ed0849408bb28a0a45fec8fa653f16242aa2ae0262bc9af9"
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
