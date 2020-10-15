class Autodiff < Formula
  desc "Automatic differentiation made easier for C++"
  homepage "https://autodiff.github.io"
  url "https://github.com/autodiff/autodiff/archive/v0.5.11.tar.gz"
  sha256 "d6c5a7ea5459c98bfd2b6fd34a883b78ef1372e3e35ae07cd40fdf7c4a5c7576"
  license "MIT"
  head "https://github.com/autodiff/autodiff.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "df9683ce241dbc7cca5798251423c81e1e10cc94e7af390a0e0e3361cdfbb26a" => :catalina
    sha256 "79753e9e6b3cce24eca76e99d59ce56c330b209d940f7873df87963a1a66302f" => :mojave
    sha256 "ed369921225b6e64e86351a7870500946fa6385990658daae9a1c9a9985342ce" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "eigen"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    (pkgshare/"test").install "examples/forward/example-forward-single-variable-function.cpp" => "forward.cpp"
    (pkgshare/"test").install "examples/reverse/example-reverse-single-variable-function.cpp" => "reverse.cpp"
  end

  test do
    system ENV.cxx, pkgshare/"test/forward.cpp", "--std=c++17",
                    "-I#{include}", "-I#{Formula["eigen"].opt_include}", "-o", "forward"
    system ENV.cxx, pkgshare/"test/reverse.cpp", "--std=c++17",
                    "-I#{include}", "-I#{Formula["eigen"].opt_include}", "-o", "reverse"
    assert_match "u = 8.19315\ndu/dx = 5.25\n", shell_output(testpath/"forward")
    assert_match "u = 8.19315\nux = 5.25\n", shell_output(testpath/"reverse")
  end
end
