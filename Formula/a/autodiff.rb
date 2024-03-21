class Autodiff < Formula
  desc "Automatic differentiation made easier for C++"
  homepage "https://autodiff.github.io"
  url "https://github.com/autodiff/autodiff/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "a5489bb546c460af52de8ead447439b3c97429184df28b4d142ce7dcfd62b82c"
  license "MIT"
  head "https://github.com/autodiff/autodiff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "17cf0578327f5896ac1fc151ea1be8055c4bc2fbd0c854ecfee2945ab953979f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8db7eeeb4a5767e42dc5979c1f2c7d08ef176f5b9a8ff750b26ed6fc54f37ce8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f87e5a030c6a8b988893cf3b245111682b3fdb6655bf02391195350cde4e1a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "15b5791e62db828b1f54c040d0c0b97b0323adf19e7e645de3fe18c4571bee8c"
    sha256 cellar: :any_skip_relocation, ventura:        "28ef141acc024bafa3b5c24e7b070a1fb2bd37c9d7f21f8f76e01d7f6dd5f4d5"
    sha256 cellar: :any_skip_relocation, monterey:       "6a5e0ceed8842ff79d708fae0a925ecf77d3c9458536d6634aab2515c346c6df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd32f73ba21fa3d0be7977f0e130d4ac2577ea3147e6cc07b5ac99a491dabc12"
  end

  depends_on "cmake" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "eigen"
  depends_on "pybind11"

  fails_with gcc: "5"

  def python3
    "python3.12"
  end

  def install
    args = %W[
      -DAUTODIFF_BUILD_TESTS=OFF
      -DPYTHON_EXECUTABLE=#{which(python3)}
    ]
    system "cmake", "-S", ".", "-B", "_build", *args, *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"

    (pkgshare/"test").install "examples/forward/example-forward-single-variable-function.cpp" => "forward.cpp"
    (pkgshare/"test").install "examples/reverse/example-reverse-single-variable-function.cpp" => "reverse.cpp"
  end

  test do
    system ENV.cxx, pkgshare/"test/forward.cpp", "--std=c++17",
                    "-I#{include}", "-I#{Formula["eigen"].opt_include}/eigen3", "-o", "forward"
    system ENV.cxx, pkgshare/"test/reverse.cpp", "--std=c++17",
                    "-I#{include}", "-I#{Formula["eigen"].opt_include}/eigen3", "-o", "reverse"
    assert_match "u = 8.19315\ndu/dx = 5.25\n", shell_output(testpath/"forward")
    assert_match "u = 8.19315\nux = 5.25\n", shell_output(testpath/"reverse")
    system python3, "-c", "import autodiff"
  end
end
