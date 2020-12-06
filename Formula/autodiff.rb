class Autodiff < Formula
  desc "Automatic differentiation made easier for C++"
  homepage "https://autodiff.github.io"
  url "https://github.com/autodiff/autodiff/archive/v0.5.13.tar.gz"
  sha256 "a73dc571bcaad6b44f74865fed51af375f5a877db44321b5568d94a4358b77a1"
  license "MIT"
  head "https://github.com/autodiff/autodiff.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "09304dc3957c4d50a207bf31a7e734d0df28529e0e40226e140790f4fba94fde" => :big_sur
    sha256 "59be27e76fd3845fb5f5592f8fcf610d767aea655eb00be72c2fd345604bc6db" => :catalina
    sha256 "f7403731e18af4a75045afa8444af6d2e01c96df0fa2ea0305b59d9b389519cf" => :mojave
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
