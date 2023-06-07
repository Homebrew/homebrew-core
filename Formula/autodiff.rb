class Autodiff < Formula
  desc "Automatic differentiation made easier for C++"
  homepage "https://autodiff.github.io"
  url "https://github.com/autodiff/autodiff/archive/v1.0.3.tar.gz"
  sha256 "21b57ce60864857913cacb856c3973ae10f7539b6bb00bcc04f85b2f00db0ce2"
  license "MIT"
  head "https://github.com/autodiff/autodiff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a90a50e5c2c406a5d6f7902680d6b7f06a29ad34445670b9a1b35b6dd9e95bd8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d09f93e264066002a82052ef4350682622740ceddf8757363426ccfe03572155"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "192d6b6b9e7b9b0a20038cf30b782b6ec2fc9f49c78e4be7e482b4d3c6e04efc"
    sha256 cellar: :any_skip_relocation, ventura:        "9ff50c5fd82428db110802b085fee58aa541be9061a564b7e39f98c0dcf53970"
    sha256 cellar: :any_skip_relocation, monterey:       "d6224d50b997a6be02918a8b2086d7a87c0afc21344fc615928bfcdf5c36b1d2"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab6fc6f7b6ec4f60cd99893e964b73a1ccf5fa09b55637f78c9cfe45124a1185"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a8250ac032d969a17876b1789d3825ead8df47954e015b7c6c6535d9de1847a"
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
