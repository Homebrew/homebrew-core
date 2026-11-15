class Lmfit < Formula
  desc "C library for Levenberg-Marquardt minimization and least-squares fitting"
  homepage "https://jugit.fz-juelich.de/mlz/lib/lmfit"
  url "https://jugit.fz-juelich.de/mlz/lib/lmfit/-/archive/v11.0.1/lmfit-v11.0.1.tar.bz2"
  sha256 "f4bdadcf959261c7dfc93402012493ae2ff307caed3418badde202a59a680d18"
  license "BSD-2-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5fddb0bcd6abb2a223e53da9d98d398786f323a268b2b644dccead0eb8cf4cd3"
    sha256 cellar: :any, arm64_tahoe:       "839792cbf8dd7a8627bdc500caf8ae6c279dce94937ca0a29bc64eac84b04a61"
    sha256 cellar: :any, arm64_sequoia:     "62cb813717de3f62c9e223d3d5e1ed666ffd9978858bd8975f29bf8f9b8d16f6"
    sha256 cellar: :any, arm64_linux:       "1483d5045101dd23fd4a750e097b1821ceb01991e3318725be59ae450584d1e6"
    sha256 cellar: :any, x86_64_linux:      "e5ee64c71c21fd70b457d6fb2c9e5c5cd02f62d10466a19051e1d8ba1ff6b46a"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "demo/curve1.c"
  end

  test do
    system ENV.cc, pkgshare/"curve1.c", "-I#{include}", "-L#{lib}", "-llmfit", "-o", "test"
    assert_match "converged  (the relative error in the sum of squares is at most tol)", shell_output("./test")
  end
end
