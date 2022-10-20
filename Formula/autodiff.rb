class Autodiff < Formula
  desc "Automatic differentiation made easier for C++"
  homepage "https://autodiff.github.io"
  url "https://github.com/autodiff/autodiff/archive/v0.6.12.tar.gz"
  sha256 "3e9d667b81bba8e43bbe240a0321e25f4be248d1761097718664445306882dcc"
  license "MIT"
  head "https://github.com/autodiff/autodiff.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a54f5763c43a7f365c15af3158cb25b54cbb75ef1a0489b7790e63b8d8d43ea7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b98245f13ff32155ce51384cadad2ebb54bc454e948189e8e0953ae494b5db1"
    sha256 cellar: :any_skip_relocation, monterey:       "d1ceec402e6011efe48e30b99358b30e4c8507e8eef8609329d496ab7d94e937"
    sha256 cellar: :any_skip_relocation, big_sur:        "0689b7aae4239a84d799bf9c84d32145070a6ceb2a5ce4af1427cb299c97e162"
    sha256 cellar: :any_skip_relocation, catalina:       "3ee91d9ebce5430a39b592f6b308f0ca0e3a51b6179acabc75e08f0f352415f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2a52a772728ba0538f5b07ce513620a191d42513b9b653d32a8167536c30889"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build
  depends_on "eigen"
  depends_on "pybind11"

  fails_with gcc: "5"

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
