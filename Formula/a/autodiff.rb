class Autodiff < Formula
  desc "Automatic differentiation made easier for C++"
  homepage "https://autodiff.github.io"
  url "https://github.com/autodiff/autodiff/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "86f68aabdae1eed214bfbf0ddaa182c78ea1bb99e4df404efb7b94d30e06b744"
  license "MIT"
  revision 1
  head "https://github.com/autodiff/autodiff.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "36551a892c3f9563a9b82689a5797d34335a409ae348d4d79d94e1989bad50dc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a73c6ac9d02e8c1c3ca4d3f306dda985d499c8c0ee8783b3e3add6d4dee5d884"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d4b5db595e0ad1b19a770f4474bbbe1f8143bc425bdafec13eb69696de271ca6"
    sha256 cellar: :any,                 arm64_linux:       "835015a3ce93b3eba5745e0cf25aacbb05dcb969acce47bfa80fbe9241b365fd"
    sha256 cellar: :any,                 x86_64_linux:      "32c88f4c7fb7d8fc545a7bff52416a32f4eb93b18f4eecd33bb197e4cf59eb8f"
  end

  # Last release on 2024-04-08 and does not work with latest Eigen
  deprecate! date: "2026-02-02", because: :unmaintained
  disable! date: "2027-02-02", because: :unmaintained

  depends_on "cmake" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.15" => [:build, :test]
  depends_on "eigen@3"
  depends_on "pybind11"

  def install
    args = %W[
      -DAUTODIFF_BUILD_TESTS=OFF
      -DPYTHON_EXECUTABLE=#{python3}
    ]
    system "cmake", "-S", ".", "-B", "_build", *args, *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"

    (pkgshare/"test").install "examples/forward/example-forward-single-variable-function.cpp" => "forward.cpp"
    (pkgshare/"test").install "examples/reverse/example-reverse-single-variable-function.cpp" => "reverse.cpp"
  end

  test do
    system ENV.cxx, pkgshare/"test/forward.cpp", "--std=c++17",
                    "-I#{include}", "-I#{formula_opt_include("eigen@3")}/eigen3", "-o", "forward"
    system ENV.cxx, pkgshare/"test/reverse.cpp", "--std=c++17",
                    "-I#{include}", "-I#{formula_opt_include("eigen@3")}/eigen3", "-o", "reverse"
    assert_match "u = 8.19315\ndu/dx = 5.25\n", shell_output(testpath/"forward")
    assert_match "u = 8.19315\nux = 5.25\n", shell_output(testpath/"reverse")
    system python3, "-c", "import autodiff"
  end
end
