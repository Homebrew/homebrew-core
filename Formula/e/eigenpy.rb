class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v3.13.0/eigenpy-3.13.0.tar.gz"
  sha256 "4e5f05ffa68a299732c6284348486d1f0c364e7f2a2bce0f14afa93780226d0b"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "devel"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d0c2c855c546ecf2b8f270cd9ca31529b9bc80916b38168b5545129e165506e6"
    sha256 cellar: :any, arm64_tahoe:       "5c4af6d007e93211474e05015e5aa7c7cac8370935e34703d94285eec9d59a1a"
    sha256 cellar: :any, arm64_sequoia:     "8b8ec75b0e074d80280f9fb365c1bfdf089592626a278740aec671d68e188d21"
    sha256 cellar: :any, arm64_linux:       "4fca656801acf74db450d5a8f67700bc624d1d11d7535c42699c38911b9b1144"
    sha256 cellar: :any, x86_64_linux:      "31224136a476e7e02d6f4b6667062ea247bcc96d74e5694c719e7290528ac82b"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build
  depends_on "boost-python3"
  depends_on "eigen"
  depends_on "numpy"
  depends_on "python@3.15"
  depends_on "scipy"

  def install
    ENV.prepend_path "PYTHONPATH", formula_opt_prefix("numpy")/Language::Python.site_packages(python3)
    ENV.prepend_path "Eigen3_DIR", Formula["eigen"].opt_share/"eigen3/cmake"

    args = %W[
      -DPYTHON_EXECUTABLE=#{python3}
      -DBUILD_UNIT_TESTS=OFF
    ]
    # Avoid linkage to boost container and graph modules
    # Issue ref: https://github.com/boostorg/boost/issues/985
    args += %w[MODULE SHARED].map { |type| "-DCMAKE_#{type}_LINKER_FLAGS=-Wl,-dead_strip_dylibs" } if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system python3, "-c", <<~PYTHON
      import numpy as np
      import eigenpy

      A = np.random.rand(10,10)
      A = 0.5*(A + A.T)
      ldlt = eigenpy.LDLT(A)
      L = ldlt.matrixL()
      D = ldlt.vectorD()
      P = ldlt.transpositionsP()

      assert eigenpy.is_approx(np.transpose(P).dot(L.dot(np.diag(D).dot(np.transpose(L).dot(P)))),A)
    PYTHON
  end
end
