class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v2.7.10/eigenpy-2.7.10.tar.gz"
  sha256 "f427c05f6daae05b9e898132c12aa5ef4c6541e841b9e65344cb4eab22371af0"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0107c1df27571eee112642452959dd9af5f66755048a4ec36ba6e5f291863ad8"
    sha256 cellar: :any,                 arm64_big_sur:  "0444b676e6b46281bdf3ea673515eadeb51fffdff91edac67135997b9099edf5"
    sha256 cellar: :any,                 monterey:       "15d464e56a1c6500993c61165f86d6fa76b18f6b724e1b177cf050183f5c5156"
    sha256 cellar: :any,                 big_sur:        "3c22a1adc4c1daf0fd1711bc958853bd729418444bc7c5ea6ca0bcae566333cf"
    sha256 cellar: :any,                 catalina:       "6fd19e430e1bf8929d5659c0bc5f3c0f4a142be5785ffa58ec722867e96f2693"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69607e5cf5b4b1c0e209acfc298328a5bacbc4749500b41140765a9b1dc50ecc"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost-python3"
  depends_on "eigen"
  depends_on "numpy"
  depends_on "python@3.10"

  def python3
    deps.map(&:to_formula)
        .find { |f| f.name.match?(/^python@\d\.\d+$/) }
        .opt_bin/"python3"
  end

  def install
    ENV.prepend_path "PYTHONPATH", Formula["numpy"].opt_prefix/Language::Python.site_packages(python3)
    ENV.prepend_path "Eigen3_DIR", Formula["eigen"].opt_share/"eigen3/cmake"

    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{python3}",
                    "-DBUILD_UNIT_TESTS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system python3, "-c", <<~EOS
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
