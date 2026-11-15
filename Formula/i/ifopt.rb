class Ifopt < Formula
  desc "Light-weight C++ Interface to Nonlinear Programming Solvers"
  homepage "https://wiki.ros.org/ifopt"
  url "https://github.com/ethz-adrl/ifopt/archive/refs/tags/2.1.4.tar.gz"
  sha256 "da38f91a282f3ed305db163954c37d999b6e95f5d2c913a63bae3fef9ffb3a37"
  license "BSD-3-Clause"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "d1c4327865bfad7e97da5fb1e19d05719ae0f468d0a931c747c70621af9d4e34"
    sha256 cellar: :any, arm64_tahoe:       "26fd541ebedd2695690d60bb297ab1c042ce0e1063c877fd046b09d0ee3d97ff"
    sha256 cellar: :any, arm64_sequoia:     "00681c3ecbdff9f3374a16527fb0d8f21138eb565f6985495ae57c0aaa6e8685"
    sha256 cellar: :any, arm64_linux:       "2eb31a088cebf2c9374e579d92fe3f5537c24d389378d4cad64c6aa57596359c"
    sha256 cellar: :any, x86_64_linux:      "066286ce5ecae8791cacab5376aaeac4308014fd8780b6b6500a1134c1789d2a"
  end

  depends_on "cmake" => :build

  depends_on "pkgconf" => :build
  depends_on "eigen"
  depends_on "ipopt"

  # Backport support for eigen 5.0.0
  patch do
    url "https://github.com/ethz-adrl/ifopt/commit/deb3209d5e34cdaa896c7432f6ee1138148ddfda.patch?full_index=1"
    sha256 "95e1ee352d1842811b2e015a78be304bfce0af867f8233f7e5e7e94aa01aae2d"
    type :backport
    resolves "https://github.com/ethz-adrl/ifopt/pull/110"
  end

  # Add missing `<iostream>` include for newer libc++
  patch do
    url "https://github.com/ethz-adrl/ifopt/commit/ca908c2f5e372b5ba9dad3573be6dd156a39d28a.patch?full_index=1"
    sha256 "15c9b47faecdfac311d9b5a67ad008c8d5a96cc5b64407a6448c909f7ec6a267"
    type :unofficial
    resolves "https://github.com/ethz-adrl/ifopt/pull/112"
  end

  deny_network_access!
  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "ifopt_ipopt/test"
  end

  test do
    cp pkgshare/"test/ex_test_ipopt.cc", "test.cpp"
    system ENV.cxx, "-std=c++14", "test.cpp", "-o", "test",
                    "-I#{formula_opt_include("eigen")}/eigen3",
                    "-L#{lib}", "-lifopt_core", "-lifopt_ipopt"
    assert_match "Optimal Solution Found", shell_output("./test")
  end
end
