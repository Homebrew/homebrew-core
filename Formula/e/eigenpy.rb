class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  license "BSD-2-Clause"
  revision 4
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "devel"

  stable do
    url "https://github.com/stack-of-tasks/eigenpy/releases/download/v3.12.0/eigenpy-3.12.0.tar.gz"
    sha256 "e6b7f17e1b7fb61e52447ceee8f47c3fc2c8f9cc4d19317e0467dc71babdb350"

    # Backport support for eigen 5.0.0
    patch do
      url "https://github.com/stack-of-tasks/eigenpy/commit/0bb71c7da9c297a334f2de419df13ba2c7a67312.patch?full_index=1"
      sha256 "812274fc7fa68e3af3ede5324590aa2e7ae06f264ac1927989dfe6e324374791"
    end
    patch do
      url "https://github.com/stack-of-tasks/eigenpy/commit/a64334c3ddbdd9ffd9f3b65a0b9c1e0d1d2b8c96.patch?full_index=1"
      sha256 "2110114b6467e5e2889ea55b9e3b2ef5f8cc965a914bfd62d2335e526551d421"
    end
    patch do
      url "https://github.com/stack-of-tasks/eigenpy/commit/2a4adb8af92eebd1dac321010db040797100b91d.patch?full_index=1"
      sha256 "ef47a99123a391c6d3a7be683d5667b3d2f94562d1b4a6c8284c8acc1928b4c2"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dbf30d75e91d68fe9d424aeef98f1f0a2cf77369b3ee1402c9ea3e3f0be96cc7"
    sha256 cellar: :any,                 arm64_sequoia: "6d6fbed231bf5729899ca1938712f80be53b82ed6db109601602347586cf7348"
    sha256 cellar: :any,                 arm64_sonoma:  "3141e4e2f7be8a9dd99aea1662e22fe7c7f441b859c9de8b6953c816822bafb0"
    sha256 cellar: :any,                 sonoma:        "b7146ccacf5e01b1317fef259dbff644e622ef5b855b9f9012234fb755dec420"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "548952eaae7925a876664c039586a4f915cb05daadc958ea959ee9f1043fce58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c539fb28ab1b1a98001186451376435b43cd5b2f101b1d72ddc32cc2ecab08a0"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build
  depends_on "boost-python3"
  depends_on "eigen"
  depends_on "numpy"
  depends_on "python@3.14"
  depends_on "scipy"

  def python3
    "python3.14"
  end

  def install
    ENV.prepend_path "PYTHONPATH", Formula["numpy"].opt_prefix/Language::Python.site_packages(python3)
    ENV.prepend_path "Eigen3_DIR", Formula["eigen"].opt_share/"eigen3/cmake"

    args = %W[
      -DPYTHON_EXECUTABLE=#{which(python3)}
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
