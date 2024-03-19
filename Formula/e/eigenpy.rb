class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v3.4.0/eigenpy-3.4.0.tar.gz"
  sha256 "ad619bda7c24a129ce5469de7dc4544220c31db1fce5d0a37ceb64824cfa8978"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "25a1e9bbd2c1338d76948e0f4d664fe318ecc197eb7d2e32e521641a7ac3ab7f"
    sha256 cellar: :any,                 arm64_ventura:  "474924e181b3983c6373d746b504b3a617453f9c6680ace12effe8beb8669b3f"
    sha256 cellar: :any,                 arm64_monterey: "82815a46df18d9aaa944453976bd3f44f9b1d41bd03f7017205b0ae130f07206"
    sha256 cellar: :any,                 sonoma:         "0891203489e3169492367eee521a86c7ba0f8aef712d5a4f2337724403117832"
    sha256 cellar: :any,                 ventura:        "2876b710abdb8e3817ed0607f5647ef2141a26540b1f8b98781af06efc096fb0"
    sha256 cellar: :any,                 monterey:       "f8787e3dfbabaf7879be0e73ffcba71b79af2a0ded477955da843b601aae6e70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c1a3faf8a6666715e9d1c92a3f33fdf2914d558c4e1a385f3c8e22e6f7bb2f0"
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
