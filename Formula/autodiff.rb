class Autodiff < Formula
  desc "Automatic differentiation made easier for C++"
  homepage "https://autodiff.github.io"
  url "https://github.com/autodiff/autodiff/archive/v0.6.12.tar.gz"
  sha256 "3e9d667b81bba8e43bbe240a0321e25f4be248d1761097718664445306882dcc"
  license "MIT"
  head "https://github.com/autodiff/autodiff.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d69df0c39e6a5bc02ede1dbf05f1d68a018205f2b23d99036e23aaa782d4d5d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6dde05e670781d1b6d590f249b38d4a1e7235df3bf716d97b41d2020cb7ae83c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae6c00fc401205db2d003d3692e19e8fa9bd1118033724a13990cc67e9838b1a"
    sha256 cellar: :any_skip_relocation, monterey:       "c9af697593908ad18fc74255b22d79fd4eb1b029ed22e4ec92ac32f89667b6c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "a6efd6b87f3062ac9bf07f7e3d3cc01d04cb2acdbfae08565e5f94fbb48ca7b2"
    sha256 cellar: :any_skip_relocation, catalina:       "fb2b3fb7181e30a35443666b115d524c00ff8a332791d2df6bd2829fc3ca4ccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8efedec30763cbeb464eed98e71c93cebcb0ab599045468e85cd78df5a7b6e4"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "eigen"
  depends_on "pybind11"

  fails_with gcc: "5"

  def python3
    "python3.11"
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
