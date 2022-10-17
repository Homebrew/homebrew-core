class Autodiff < Formula
  desc "Automatic differentiation made easier for C++"
  homepage "https://autodiff.github.io"
  url "https://github.com/autodiff/autodiff/archive/v0.6.12.tar.gz"
  sha256 "3e9d667b81bba8e43bbe240a0321e25f4be248d1761097718664445306882dcc"
  license "MIT"
  head "https://github.com/autodiff/autodiff.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "406ead47f01c74683d3ad50e34e95400abc4958dcc2b7790bccba3125bfc3c3f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7a73ac5bc2db3d82213d448986b23e76de92f8d20db99cdbda50a02021d8ab5"
    sha256 cellar: :any_skip_relocation, monterey:       "9be76087019acfe20b9ba2291de93af0919f1f1b352100137fe76cb0b30a0af4"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0a44913812ab1f56b57bb8ef06963e54b77cf07a73c834c973c45e4ed9eb51c"
    sha256 cellar: :any_skip_relocation, catalina:       "dd8a303a162a586491296596e636404da223eb136201fdb4962ef8ef507ab478"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "349adde7dab336c96737265fdc4e3d8e93d4c3b25d2db321e360d0a455a69d68"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build
  depends_on "eigen"
  depends_on "pybind11"

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
