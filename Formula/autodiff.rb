class Autodiff < Formula
  desc "Automatic differentiation made easier for C++"
  homepage "https://autodiff.github.io"
  url "https://github.com/autodiff/autodiff/archive/v0.6.6.tar.gz"
  sha256 "2a4498b09da9a223b896a3bbfc9ebcb7c7c0b906b19a25000e6f3b94698d916d"
  license "MIT"
  head "https://github.com/autodiff/autodiff.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f383a9380292ebd0780141f13d09b74fca197a76c86e2f699ec66bd4c11eb340"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba45df80dee6bf1e5c00cb4c8d52d66be260fbad9ead68dff18274fcdb9cf118"
    sha256 cellar: :any_skip_relocation, monterey:       "15c1c82af7b202a39db7f824e02597de9aff35866be4483115b9ff26fec0818c"
    sha256 cellar: :any_skip_relocation, big_sur:        "8542aa380961c401581f79dfdebc8494818924c3e0ee9e6fe9a7bbe0a607df45"
    sha256 cellar: :any_skip_relocation, catalina:       "4e48bc6bc5af21478837be025b58ad50fa2f032870dc6cf52d2249cfa3cf762b"
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
