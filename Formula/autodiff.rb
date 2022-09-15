class Autodiff < Formula
  desc "Automatic differentiation made easier for C++"
  homepage "https://autodiff.github.io"
  url "https://github.com/autodiff/autodiff/archive/v0.6.11.tar.gz"
  sha256 "ac7a52387a10ecb8ba77ce5385ffb23893ff9a623467b4392bd204422a3b5c09"
  license "MIT"
  head "https://github.com/autodiff/autodiff.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "791f4bcc0c3443bea4e021975e796a995373c24c8324eee6d87c59a2c92b52b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe483c1c5f4e1e77869218dc0733774c69a468ac1d5a5b703bc8eb2c8350856a"
    sha256 cellar: :any_skip_relocation, monterey:       "46e42cf85d0383662c1b1e147f8aeebd1ee7a355f62d74edfd673207f273e54f"
    sha256 cellar: :any_skip_relocation, big_sur:        "47ca8ddf8ce79fdc95104ddd74a2ff37473445c9d7ae3a77ff67248388c04cc1"
    sha256 cellar: :any_skip_relocation, catalina:       "004781f0224d9bdcefcf720f2defc2d82f112338fde7229cc4f446c1108214a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5242b237a2bb5edd12d26569c7fceb9eaf3a73a48c88dc2fbe8003aa57d00632"
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
