class Autodiff < Formula
  desc "Automatic differentiation made easier for C++"
  homepage "https://autodiff.github.io"
  url "https://github.com/autodiff/autodiff/archive/v0.6.3.tar.gz"
  sha256 "afcc21c74c9c20ecf08c53ab82965652438d5bb65d146a2db43795b051c12135"
  license "MIT"
  head "https://github.com/autodiff/autodiff.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5d115a24200aeaf67131453c70b6082be66d99d2920d43d3857a90f68b54945d"
    sha256 cellar: :any_skip_relocation, big_sur:       "e56abb1cfd0a276322bb136d08b5037285e12fff7cdcd703897928173b997383"
    sha256 cellar: :any_skip_relocation, catalina:      "15ffb5d75d4993904a407b58a57d2c5dc00898a09ecaaa0047fbbb5c6519bc06"
    sha256 cellar: :any_skip_relocation, mojave:        "646362ffbcd6dfe2f0822b700483eafe8a6cb939326a30fa7112e893c1495a01"
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
