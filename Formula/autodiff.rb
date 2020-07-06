class Autodiff < Formula
  desc "Automatic differentiation made easier for C++"
  homepage "https://autodiff.github.io"
  url "https://github.com/autodiff/autodiff/archive/v0.5.10.tar.gz"
  sha256 "d0e62994b7984014b2944d13f6ce9a75fc6b681d2d81f9051ec44410912dc5d7"
  license "MIT"
  head "https://github.com/autodiff/autodiff.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0be7da5b5c8cb88296037137126dc4530f23559509b6a93d33485db8ae74446c" => :catalina
    sha256 "a8a8c129b51be0a90a7f683b52010d42a56439c869beeac44ed77e16a8d406b0" => :mojave
    sha256 "464905e7e857c916c85a3c60757ae1ab21834e0187161185043fd52c29fa7fb7" => :high_sierra
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
    assert_match shell_output(testpath/"forward"), shell_output(testpath/"reverse")
  end
end
