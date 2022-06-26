class Autodiff < Formula
  desc "Automatic differentiation made easier for C++"
  homepage "https://autodiff.github.io"
  url "https://github.com/autodiff/autodiff/archive/v0.6.8.tar.gz"
  sha256 "680fc476ed218a3a0eeb0de017d427921189b50c99e1c509395f10957627fb1a"
  license "MIT"
  head "https://github.com/autodiff/autodiff.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c44721ca58d12db3d76c0e419bee7f665c44e02fae6ea472e8fec9c5ed2796d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2283a1bfdd3acc24fca51b62a777757f70283eb5ee0b6aeff40a0e84d061edc"
    sha256 cellar: :any_skip_relocation, monterey:       "b1febb629a3910d1352c0607d8dcdb2dd6e4c2f725b45036c7a85939f06fea09"
    sha256 cellar: :any_skip_relocation, big_sur:        "468d6ee2abb1e404d559abe3a7c665fc54e4c03547e93a7d7c7340fed78cb23e"
    sha256 cellar: :any_skip_relocation, catalina:       "1b6a2b25f7091a730c473d8db5241920c5636ee926d0461291a22edbed31f167"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0078dabb50ed0c8ed879c287e4c0ffac7dcd524c68c460b28a44b86b636717fc"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build
  depends_on "eigen"
  depends_on "pybind11"

  on_linux do
    depends_on "gcc"
  end

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
