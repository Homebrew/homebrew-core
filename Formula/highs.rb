class Highs < Formula
  desc "Linear optimization software"
  homepage "https://www.maths.ed.ac.uk/hall/HiGHS/"
  url "https://github.com/ERGO-Code/HiGHS/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "4b9441cb991e372b2d4fa4a85e89db199befa1b0017a3275b45ad5ef734efaca"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "90bb5d131f97816884aac1bc360ec9c6586ced31a0f694330313ad5f4d8a9db9"
    sha256 cellar: :any,                 arm64_monterey: "12291ca9e3432902f7d52ac67f011d47e2b12d61097b89ea5d85b00e587a8482"
    sha256 cellar: :any,                 arm64_big_sur:  "9ec55d6e6ca31b6bfdac3283efb928a743c5470bccffa05130822b63932f6b87"
    sha256 cellar: :any,                 ventura:        "553d4cb17009884f166fb4bc9d330dd9a9a16f6bfb8f318f3f68ae5e8ba298f8"
    sha256 cellar: :any,                 monterey:       "e6c4eb1a40199a371e21a8c834beec5b8f6b7f8a3886500652f13d3c737f9364"
    sha256 cellar: :any,                 big_sur:        "11cdb98fffce84422abadeba6d00216acabc4a63377f24de7645b13a2c6aa1f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0b6a82164a5f77b4badec0a74eda55ee1b4d509faeda002fb7030852c7fbeb3"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "check", "examples"
  end

  test do
    output = shell_output("#{bin}/highs #{pkgshare}/check/instances/test.mps")
    assert_match "Optimal", output

    cp pkgshare/"examples/call_highs_from_cpp.cpp", testpath/"test.cpp"
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}/highs", "-L#{lib}", "-lhighs", "-o", "test"
    assert_match "Optimal", shell_output("./test")
  end
end
