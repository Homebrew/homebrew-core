class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v3.10.0/eigenpy-3.10.0.tar.gz"
  sha256 "041ca892a9dab2cd81ba828aeb247adfd44438db5d6037ed61fde1e833a3edbe"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6755fd097be0a2af177d1fc502a7f26ac7ade3e9129b5401b1808d4318a3ce96"
    sha256 cellar: :any,                 arm64_sonoma:  "d295b64c7a85cb8d508188164db5e1629e34387e2388da5b3fed67c745c273e0"
    sha256 cellar: :any,                 arm64_ventura: "67edbc7ee532f0817c082d3e7e965f0ce137fafa43e5c6a89b9be98450e32934"
    sha256 cellar: :any,                 sonoma:        "50eb458e69802b78a77c63005f53781b965a5a853dd63d5d4df9bdc6c9a3e586"
    sha256 cellar: :any,                 ventura:       "3e20a28dd0787593b8bf1c44c68b28fb21440792cf95f7b525725e94fe34c928"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b389d8b06851055dbf2a54f9ea0d02ecd524c77c88b2e5a724c86e8fa1c91d94"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "boost-python3"
  depends_on "eigen"
  depends_on "numpy"
  depends_on "python@3.12"
  depends_on "scipy"

  def python3
    "python3.12"
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
