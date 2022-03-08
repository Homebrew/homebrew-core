class Autodiff < Formula
  desc "Automatic differentiation made easier for C++"
  homepage "https://autodiff.github.io"
  url "https://github.com/autodiff/autodiff/archive/v0.6.6.tar.gz"
  sha256 "2a4498b09da9a223b896a3bbfc9ebcb7c7c0b906b19a25000e6f3b94698d916d"
  license "MIT"
  head "https://github.com/autodiff/autodiff.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43ca6932cf78994ac0e84ca0db2deff9b76b22c864a497e4eda6790365f895b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3fed4acfe7e6b3bdf8ceae4762187540484576c0191a55db270d51756bb4363d"
    sha256 cellar: :any_skip_relocation, monterey:       "738db87fc43476e3ca4a5102c4bcffe568c499d4dfe999afe27e0bd72e6aec1d"
    sha256 cellar: :any_skip_relocation, big_sur:        "97a21fa250a573d1a0a6c3d99ef1b58f38854e6354ce8d78db8d5bc95859cf5d"
    sha256 cellar: :any_skip_relocation, catalina:       "e3060054265e6eb197cc6b1c633f56d17588e67fceeacbddc8d08f164ca1216f"
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
