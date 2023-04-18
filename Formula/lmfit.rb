class Lmfit < Formula
  desc "C library for Levenberg-Marquardt minimization and least-squares fitting"
  homepage "https://jugit.fz-juelich.de/mlz/lmfit"
  url "https://jugit.fz-juelich.de/mlz/lmfit/-/archive/v9.0/lmfit-v9.0.tar.bz2"
  sha256 "773d8c9f8755727e70cb3e6b70069e3e0b7a3cb163183e44f2cff6dc1ea503fb"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d19ccd618608a60bf8de2fe961409cf5615f7003500e88a2157dfffbed40aac5"
    sha256 cellar: :any,                 arm64_monterey: "b987b349c6ebe7de26d3df3f1533a8b2aaed6e021e30478a623be0d84654304b"
    sha256 cellar: :any,                 arm64_big_sur:  "5847e9700579b8e38168fe822e779f1c1e4b74d0acc41b2571e44d67da62f5ee"
    sha256 cellar: :any,                 ventura:        "9ba40546fc4b1ac3a04517312788ec9650b11379fcf0ed66fad8599a5a6f01b7"
    sha256 cellar: :any,                 monterey:       "4da2bb131ad773aa9b58d27a850619efd8e5fbcb13549c2b02fd2644af59fe63"
    sha256 cellar: :any,                 big_sur:        "08be04ba47f0947f21704736cc71f61fee920de95ebfcedba5ef8091cce34f49"
    sha256 cellar: :any,                 catalina:       "b523a336000b11de635407d0f824068219b298043bf39a520e6777bcfbf18fa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d3fd83e276cd33f98bd50f5ff20b8ba67e4b1782a808bd057684fe72996db4d"
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
