class Autodiff < Formula
  desc "Automatic differentiation made easier for C++"
  homepage "https://autodiff.github.io"
  url "https://github.com/autodiff/autodiff/archive/v0.5.13.tar.gz"
  sha256 "a73dc571bcaad6b44f74865fed51af375f5a877db44321b5568d94a4358b77a1"
  license "MIT"
  head "https://github.com/autodiff/autodiff.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d82c564c95a5d6ff0e74993ee5f0402b9d8d9680ec80bf756851ae86d4cc57aa" => :big_sur
    sha256 "fde07b4c7f1c1fa1c004e0449a7a9fbb32535105c142de4325cd602e629db9a3" => :catalina
    sha256 "33ea270a121b13a25f1f28ba844cb78a0e0c9bacf4d1df2e6bb8993e8c6b4fab" => :mojave
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
