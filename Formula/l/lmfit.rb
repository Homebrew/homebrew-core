class Lmfit < Formula
  desc "C library for Levenberg-Marquardt minimization and least-squares fitting"
  homepage "https://jugit.fz-juelich.de/mlz/lmfit"
  url "https://jugit.fz-juelich.de/mlz/lmfit/-/archive/v10.0/lmfit-v10.0.tar.bz2"
  sha256 "232658736984365ad71ac76adf94d125ee0df1f570a6c69ce3a34f892be14150"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e30e6afe8c7246d88c2ecc8cfd62cc3c326e035a8ea67fd2546960d23d476f55"
    sha256 cellar: :any,                 arm64_sequoia: "6d995c18ee8647862cc3ef8f49a89b3260b74f8b0162b27ea63eb965adcee02e"
    sha256 cellar: :any,                 arm64_sonoma:  "b540071bc480f6f445d956611bed6d3818f41de82a2e02e0337cc0322780adcc"
    sha256 cellar: :any,                 sonoma:        "9ba0e39ce1f606cf8ef93827b70ace200f5847094d02c2001b930c4baacc6582"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39da5cc940190e897a5b4cd90787d8cf75c68ddba48a02936b3f2e214f049883"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97ced0fb2d37329984bd28388f20b26c0633bbd79c7f53dfa38201678f730233"
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
