class Autodiff < Formula
  desc "Automatic differentiation made easier for C++"
  homepage "https://autodiff.github.io"
  url "https://github.com/autodiff/autodiff/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "86f68aabdae1eed214bfbf0ddaa182c78ea1bb99e4df404efb7b94d30e06b744"
  license "MIT"
  revision 1
  head "https://github.com/autodiff/autodiff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e710233eea192e5eb1cafc35744e0c112c2015b1c953b04951f80a8441c19861"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9884600e74258251a3b98f12dfe91649864da02aa4eb20bec25183d365e9270f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bd150a2d334136661c09b9b39cfde2ac583be0c01f3e3337dab5ce991d7e128"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5ab6b8e788bb486b1149856f048184b0e9925c9613892a8a556aea6481a157f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08b090f52b399f776b1d4b1a7601f2a81d75793b0617c942dc235d70cfea41f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ed20441a603fa36b2ca44607e1511a644aa5e6255f51cf7e07630da0ef86518"
  end

  depends_on "cmake" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "eigen@3"
  depends_on "pybind11"

  def python3
    "python3.14"
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
                    "-I#{include}", "-I#{Formula["eigen@3"].opt_include}/eigen3", "-o", "forward"
    system ENV.cxx, pkgshare/"test/reverse.cpp", "--std=c++17",
                    "-I#{include}", "-I#{Formula["eigen@3"].opt_include}/eigen3", "-o", "reverse"
    assert_match "u = 8.19315\ndu/dx = 5.25\n", shell_output(testpath/"forward")
    assert_match "u = 8.19315\nux = 5.25\n", shell_output(testpath/"reverse")
    system python3, "-c", "import autodiff"
  end
end
