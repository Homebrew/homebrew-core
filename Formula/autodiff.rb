class Autodiff < Formula
  desc "Automatic differentiation made easier for C++"
  homepage "https://autodiff.github.io"
  url "https://github.com/autodiff/autodiff/archive/v1.0.1.tar.gz"
  sha256 "63f2c8aaf940fbb1d1e7098b1d6c08794da0194eec3faf773f3123dc7233838c"
  license "MIT"
  head "https://github.com/autodiff/autodiff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1152952a96a07c31ea880f2e8fc3f874b44a5235f98ab268efae86beeb35722"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1fec5054d836642476231566e59ae43bf121e1a9620b4152b638c21578ab489"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a13d01c5b8f834804d9525d04d52ca42158a89a6ddd31282ce14591d144d5432"
    sha256 cellar: :any_skip_relocation, ventura:        "60e873a61aff0c54b79f3b309477e0691087e3d40372218c3133c6fe70fdeb21"
    sha256 cellar: :any_skip_relocation, monterey:       "621b8f93af3389890e3499c544cc233175de49fbad5a3931ad8bb73b1078f968"
    sha256 cellar: :any_skip_relocation, big_sur:        "a03382f7b4de3f8f9a6ff1a21f040c3dd14e825dbfed9ef1e2a5399150f74be3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a858fa06c093ffb988ed650fc9758d389e1c0df2fde4d607bcbe401d29c8938"
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
