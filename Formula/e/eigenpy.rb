class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v3.5.1/eigenpy-3.5.1.tar.gz"
  sha256 "f01eb2df88f3f470d7bd0c90716170e59f1495f5631525646c9f9378db5c127a"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bd25ab710eacc2ca53d852c5b5f8b3d08c29ff02ff42e334473d665df6d5b6e6"
    sha256 cellar: :any,                 arm64_ventura:  "73ed0343944d9b36e11c7be1d38650783cac0aaff290266abd9d0668ded5fd9e"
    sha256 cellar: :any,                 arm64_monterey: "e2290cee28cd0b7bad19594c1da3ffa0c9487cf77b83d5c9f07a01b6d4befac5"
    sha256 cellar: :any,                 sonoma:         "deead75eec8201f13c9daba60be69914619e7a6ac53dad0f29835325eeeac08d"
    sha256 cellar: :any,                 ventura:        "2a2088570755b5ad5361c5215f815fcd669edc94af5bf817ad86d0530cd572b6"
    sha256 cellar: :any,                 monterey:       "7cf5057cedc20fcae573d0395ca994e92c8123eca23fe3acd45e6a08f2a38971"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "111a9100cb7b1d35591d600dc69b085962b82ecaa4995f42c7b450733ee02886"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
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
