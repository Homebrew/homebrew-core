class Highs < Formula
  desc "Linear optimization software"
  homepage "https://www.maths.ed.ac.uk/hall/HiGHS/"
  url "https://github.com/ERGO-Code/HiGHS/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "e849276134eb0e7d876be655ff5fe3aa6ecf1030d605edee760620469f9e97cf"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c64a5f1c99486d75c63b0a217e3fcb1755712ee95d92d49415f0a742fdd275d0"
    sha256 cellar: :any,                 arm64_big_sur:  "00f9c3745e6fab6aa9d3a2ccafebcf91e51bafd7333ebf188afa6af9f33dd17e"
    sha256 cellar: :any,                 monterey:       "9b93504258c67a38e16019538f0ec363c94c8973d66c648607dee5f26e404c60"
    sha256 cellar: :any,                 big_sur:        "52551f4364ac1e916d15bfe14535849a0d21fe35dd10b2f6a26da73558033d30"
    sha256 cellar: :any,                 catalina:       "242f8e91cc9131f9b6bcf095299f6b948305ccd10b321b6e0e6115b9371e4f52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3de39c3b6b601c5b2497a84a66eb9075978171da2932f615e303c31f2382bf1"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gcc" # for gfortran
  depends_on "osi"

  uses_from_macos "zlib"

  def install
    system "cmake", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "check", "examples"
  end

  test do
    output = shell_output("#{bin}/highs #{pkgshare}/check/instances/test.mps")
    assert_match "Optimal", output

    cp pkgshare/"examples/call_highs_from_cpp.cpp", testpath/"test.cpp"
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lhighs", "-o", "test"
    assert_match "Optimal", shell_output("./test")
  end
end
