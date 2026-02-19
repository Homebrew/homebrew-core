class Ifopt < Formula
  desc "Light-weight C++ Interface to Nonlinear Programming Solvers"
  homepage "https://wiki.ros.org/ifopt"
  url "https://github.com/ethz-adrl/ifopt/archive/refs/tags/2.1.4.tar.gz"
  sha256 "da38f91a282f3ed305db163954c37d999b6e95f5d2c913a63bae3fef9ffb3a37"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "864f67e4c11108278a44b019f9a10520097c130d228a634a83e23875eb36ed73"
    sha256 cellar: :any,                 arm64_sequoia: "4d908163e23317019cf4fc7d2a8ea8a1b35f5bdf7ef67d787c6dca0dc3464c71"
    sha256 cellar: :any,                 arm64_sonoma:  "d590493307a718a9917354c099f0270568b2638c92e5171d39483aab9601d9c9"
    sha256 cellar: :any,                 sonoma:        "3976d40d74d9048118daf380378bc640c6021de1937ea449d3734a05de924e0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "957a65e9e0bfa0b1cea42e6d6fa0be3d1f362bc8d3070f0a2cdfde313cbec2dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fd84637f15ad2aa59f01b9c42186bf9bc76d5a3ffd2a8d1e95af3b4e70ed7f3"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "eigen"
  depends_on "ipopt"

  # Apply open PR to support eigen 5.0.0
  # PR ref: https://github.com/ethz-adrl/ifopt/pull/110
  patch do
    url "https://github.com/ethz-adrl/ifopt/commit/deb3209d5e34cdaa896c7432f6ee1138148ddfda.patch?full_index=1"
    sha256 "95e1ee352d1842811b2e015a78be304bfce0af867f8233f7e5e7e94aa01aae2d"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "ifopt_ipopt/test"
  end

  test do
    cp pkgshare/"test/ex_test_ipopt.cc", "test.cpp"
    system ENV.cxx, "-std=c++14", "test.cpp", "-o", "test",
                    "-I#{Formula["eigen"].opt_include}/eigen3",
                    "-L#{lib}", "-lifopt_core", "-lifopt_ipopt"
    assert_match "Optimal Solution Found", shell_output("./test")
  end
end
