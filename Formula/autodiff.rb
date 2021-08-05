class Autodiff < Formula
  desc "Automatic differentiation made easier for C++"
  homepage "https://autodiff.github.io"
  url "https://github.com/autodiff/autodiff/archive/v0.6.2.tar.gz"
  sha256 "b065ac0ec4a94763567a3e7bd79a7d88f464a2028957bfcb994b923a0917c5e6"
  license "MIT"
  head "https://github.com/autodiff/autodiff.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e5b36d027de4ff99c71de9435ea505260390c05354300c2dc1e80a828e883643"
    sha256 cellar: :any_skip_relocation, big_sur:       "8c32143624a1455ea1bb8fc383c7339b5fe9e18d826ffb1e76958ae92c8d9ccc"
    sha256 cellar: :any_skip_relocation, catalina:      "17fb18e3ef892158ab14076c5cde5c44680ffa4451bedda27ad21e0c92d62c15"
    sha256 cellar: :any_skip_relocation, mojave:        "62e1d5fb33c382909abf34677629ff4734b8d8486597259eafc2e6a4597a47b5"
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
