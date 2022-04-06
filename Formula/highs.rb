class Highs < Formula
  desc "Linear optimization software"
  homepage "https://www.maths.ed.ac.uk/hall/HiGHS/"
  url "https://github.com/ERGO-Code/HiGHS/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "8d0230369762a1835e075fe41fa4f83b403c21355958135c44dd214203a43edd"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "509970f3c2ca824ebd2bc2df412f1d5c5c3ed0fa11a1802c98dad94ba0e5ae2c"
    sha256 cellar: :any,                 arm64_big_sur:  "adb21a7a56b10466aea5f5fb714fb8089a9ba6c9f4c54a3e8e8e551cc52f1d58"
    sha256 cellar: :any,                 monterey:       "173e46089ef4cc6bc22e6466fdfa040466f1477a08bd93f49fee7183c6103bec"
    sha256 cellar: :any,                 big_sur:        "3d9848b15cba32e2dedcb7973d75393efebb4948ba01a52273ec68a00a354820"
    sha256 cellar: :any,                 catalina:       "6310bdc2862acaa9e3612f261de1a04e240a9b6ed1a69e55899fa8237ba85e8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8ed517817a8510201273c0778a5c94aea3dd7d5b494bac0ab6594206900f84f"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gcc" # for gfortran
  depends_on "osi"

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
