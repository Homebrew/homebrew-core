class Autodiff < Formula
  desc "Automatic differentiation made easier for C++"
  homepage "https://autodiff.github.io"
  url "https://github.com/autodiff/autodiff/archive/v1.0.3.tar.gz"
  sha256 "21b57ce60864857913cacb856c3973ae10f7539b6bb00bcc04f85b2f00db0ce2"
  license "MIT"
  head "https://github.com/autodiff/autodiff.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e18a4195b2b9cac0708f49cc54c039778dcf113370746338092ee999a8739519"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8c09e5877fd17bebf49215bf059bc33b73866bfa3e49a405d9ce9b973810ca0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5c2a195565a9dd9da5feb6e55636405ce5089d98204921d29d0350e95050f4f"
    sha256 cellar: :any_skip_relocation, sonoma:         "bd918b0a4be4a6988aabf5a2eaeaa4c80b9ef455c4be804a01566893bfa12b2a"
    sha256 cellar: :any_skip_relocation, ventura:        "4e6e331c5f1b2f3fae3aa2ab1404b1b34ca79364d55a8039758645e432572f18"
    sha256 cellar: :any_skip_relocation, monterey:       "2e13fca1888ccd7946eb0c0f558321069f1b4ea5ea12520bd73d0fe0d047cd28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84d5ac57af23463a1cdcefcc44907cf884232d9e8a39c350986cfab1643240bf"
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
    system "cmake", "-S", ".", "-B", "_build",
                    "-DAUTODIFF_BUILD_TESTS=OFF",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
                    *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
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
    system python3, "-c", "import autodiff"
  end
end
