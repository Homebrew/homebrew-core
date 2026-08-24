class Lmfit < Formula
  desc "C library for Levenberg-Marquardt minimization and least-squares fitting"
  homepage "https://jugit.fz-juelich.de/mlz/lib/lmfit"
  url "https://jugit.fz-juelich.de/mlz/lib/lmfit/-/archive/v11.0/lmfit-v11.0.tar.bz2"
  sha256 "5289b1264f82cd9a62d445848dc17d2fce1cdc0079b24594f52d87c12e1ac716"
  license "BSD-2-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8325326f02febd3bed4b3f82e1786a549eebb09d7ee63e37c0cb166912499852"
    sha256 cellar: :any, arm64_sequoia: "84efab725eb2905d1b8f0f3393ef8d3394dcf79d5ce6c254cd1e3d1723a6eb9a"
    sha256 cellar: :any, arm64_sonoma:  "28d0692c53ce1acb0df97a330bbe34a42c234967c86c190e6b4eb372626616b5"
    sha256 cellar: :any, sonoma:        "505f26d0080e19f557fa83eaffd86f42ed4f41244d84a4ebc6ec745cc58448ec"
    sha256 cellar: :any, arm64_linux:   "4e9ac03c3876b0afeb3fb5fd0473bd6a7257cf10eea5874216a118fc040122a1"
    sha256 cellar: :any, x86_64_linux:  "ec55319502ac26e95fc77ebc244bbc80d2b99e5cd5b1533ff66202d7bdcc0b0b"
  end

  depends_on "cmake" => :build

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
