class Autodiff < Formula
  desc "Automatic differentiation made easier for C++"
  homepage "https://autodiff.github.io"
  url "https://github.com/autodiff/autodiff/archive/v0.6.2.tar.gz"
  sha256 "b065ac0ec4a94763567a3e7bd79a7d88f464a2028957bfcb994b923a0917c5e6"
  license "MIT"
  head "https://github.com/autodiff/autodiff.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "419de6944eac22517aac5413585d1dc28aa4669a758b1319b831782a1fb7dcc0"
    sha256 cellar: :any_skip_relocation, big_sur:       "3cf0b3851015949beff4b7d93eba8c1220fa335f57f381afc9a45d64ed845268"
    sha256 cellar: :any_skip_relocation, catalina:      "81c921c1f24677d218e23b1c0cdaad193b72fd94e90b38828bf534fdaec1cf5d"
    sha256 cellar: :any_skip_relocation, mojave:        "f0eba3c9ab84d913a77544bf6eea416ec910b37c5318092b3e543a6069a4f81f"
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
