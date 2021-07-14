class Autodiff < Formula
  desc "Automatic differentiation made easier for C++"
  homepage "https://autodiff.github.io"
  url "https://github.com/autodiff/autodiff/archive/v0.6.1.tar.gz"
  sha256 "b2e8ed18ee6eb39cac9232f8cd0c29b9cd08a236417740361f5ac46118bf9374"
  license "MIT"
  head "https://github.com/autodiff/autodiff.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "373f892bc8d25878cfde6c6ea9b8b31b7dabc29259f06f232fbe0c71177f3bb0"
    sha256 cellar: :any_skip_relocation, big_sur:       "05fe23cf17c6b3441bd540a51c571ed3a23208c210af5b506e2f94b7d5d93dd3"
    sha256 cellar: :any_skip_relocation, catalina:      "d8568f96885d58f09bfbce989b9a049c20572e4baf02f0cac1cdccf5202d7d7a"
    sha256 cellar: :any_skip_relocation, mojave:        "9c8c50aeb1fd122871297f038eaf7f0d98f2380c08755ee6ec2975a76af6e4f4"
  end

  depends_on "cmake" => :build
  depends_on "eigen"
  depends_on "pybind11"

  def install
    system "cmake", ".", *std_cmake_args, "-DAUTODIFF_BUILD_TESTS=off"
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
