class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v3.14.0/eigenpy-3.14.0.tar.gz"
  sha256 "876fffa34eeed6789bc88d170e18d895a9fecfa2f2334d768168ac414218b3f7"
  license "BSD-2-Clause"
  compatibility_version 1
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "devel"

  bottle do
    manifest_sha256 "de97150779b94f6baf185fc6971960522437203c228fc0612fbe583c3fb9a88a"
    sha256 cellar: :any, arm64_golden_gate: "406c957cba0d87d40bb6afceef0aa1f6aca343fafa408e888a47ab89c3e57326"
    sha256 cellar: :any, arm64_tahoe:       "e69340022a066c98f4f30d6dcd325f16202650086f4c1ba71de16c1c66aa4d8c"
    sha256 cellar: :any, arm64_sequoia:     "cd8893904ad46fd1458137c54765711ef01488e9755ee233d917cddc631ab45d"
    sha256 cellar: :any, arm64_linux:       "49a38a68f069fbf0d4a7fdf8ce417d6c1b580fb5f726b878df51cda00b4a7606"
    sha256 cellar: :any, x86_64_linux:      "75753321b5b610f4cbff6d18e7d9f9b03b78b1dc4401978c5475128543f6cb67"
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

  deny_network_access!

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
