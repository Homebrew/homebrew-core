class Highs < Formula
  desc "Linear optimization software"
  homepage "https://www.maths.ed.ac.uk/hall/HiGHS/"
  url "https://github.com/ERGO-Code/HiGHS/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "e849276134eb0e7d876be655ff5fe3aa6ecf1030d605edee760620469f9e97cf"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "26d2d8fbeae81df91fe3348636e97d641c1dc0989ec892aaa235ae4c296b7093"
    sha256 cellar: :any,                 arm64_big_sur:  "61e7c4d8b1e6d4aa7f1b104e1f6709603a438d2845893c7fdd84c59d5e525a4b"
    sha256 cellar: :any,                 monterey:       "82b3ca6fd49a1d5df8d813c6c399c4c4448c78282f3cadd8c92c2aec4ff22bd6"
    sha256 cellar: :any,                 big_sur:        "b9a13ed6b3a4808b9844311025b268c2b2183ed95e0de7317086b9268e7639ba"
    sha256 cellar: :any,                 catalina:       "abb55d89a64ae65f39c3bbf1e803d8d8c50e9aef392956f3ae4afb18abfa0f40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2ec1937168d4834292359728815f13643fe832d878b59ee56976d2ffc01636b"
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
