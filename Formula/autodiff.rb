class Autodiff < Formula
  desc "Automatic differentiation made easier for C++"
  homepage "https://autodiff.github.io"
  url "https://github.com/autodiff/autodiff/archive/v0.6.7.tar.gz"
  sha256 "1345021d74bfd34e74a58d98f4e0e16cc4666b6cd18628af0ba642a6521aadfa"
  license "MIT"
  head "https://github.com/autodiff/autodiff.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73545e43853feedf25b02eea8001a489bb351b6da0a8cf4d982163522caae518"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc281d0e3235051a65704a385e037ccff5e73f6d95b08087b2c01cd274b0cf18"
    sha256 cellar: :any_skip_relocation, monterey:       "ce05ae2babf5af15cebe2c92142ffac7a616646a33247ebcbcfcdd065323036b"
    sha256 cellar: :any_skip_relocation, big_sur:        "03b6c61d9c6566630449b08af22c14378925fb49352a38412b40c44ca88e3ebc"
    sha256 cellar: :any_skip_relocation, catalina:       "a4121ba580e4b4842f67b27bac57cfced23d81d7b253ab7117a14d4c8997a8d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16ee18662b1c50d43e8386f8752a942c2886fb13b86ac292afee25b1fbe8cd9d"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build
  depends_on "eigen"
  depends_on "pybind11"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

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
