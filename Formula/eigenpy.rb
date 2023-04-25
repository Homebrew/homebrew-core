class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v3.0.0/eigenpy-3.0.0.tar.gz"
  sha256 "00848b0ccb52533a7b2cdc36d3f8caf2276e274bbbcce6577f5fb014ac1dd9af"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ec1d572d65b07b8f76bb35e1ce4f849663096c30975dcd367f247f2fee410a31"
    sha256 cellar: :any,                 arm64_monterey: "1c5190542a9c92452e0f379ca96641be76864845e2f91feeb6d65d5e5b1b22bd"
    sha256 cellar: :any,                 arm64_big_sur:  "0c0be7273471e40ca9a8f1f31249fdb6c74e10060311ac4aa02f101e0c52f73f"
    sha256 cellar: :any,                 ventura:        "4eebf4de2aa4ef6b74b6a9e1cd00b7d67e44aa631d658dfbb593dbc5b4990943"
    sha256 cellar: :any,                 monterey:       "4c5c572bf98fd92c652f2b685c89a0d72a2ee0e7dbcbd00e360067a13076e7b2"
    sha256 cellar: :any,                 big_sur:        "702bee2bc7c91d5a0651638157b7943ec6cf475d63d40d024b5e57bd2d07e9b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e1a2a195d730366e152a6a0668a0dcef2980b424f3adc309d265ae54ded7404"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost-python3"
  depends_on "eigen"
  depends_on "numpy"
  depends_on "python@3.11"

  def python3
    "python3.11"
  end

  def install
    ENV.prepend_path "PYTHONPATH", Formula["numpy"].opt_prefix/Language::Python.site_packages(python3)
    ENV.prepend_path "Eigen3_DIR", Formula["eigen"].opt_share/"eigen3/cmake"

    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
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
