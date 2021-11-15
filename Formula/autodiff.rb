class Autodiff < Formula
  desc "Automatic differentiation made easier for C++"
  homepage "https://autodiff.github.io"
  url "https://github.com/autodiff/autodiff/archive/v0.6.4.tar.gz"
  sha256 "cfe0bb7c0de10979caff9d9bfdad7e6267faea2b8d875027397486b47a7edd75"
  license "MIT"
  head "https://github.com/autodiff/autodiff.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5105ff070861435bbcb5d9d0d7a60dd1152cd53e4a81073d8715586513fc2da5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb8dd848ff068721e8c8d0d58e7b62e031ad0eebacfea36d693bc7528264d5be"
    sha256 cellar: :any_skip_relocation, monterey:       "583df3c20e81bf85eea85e60554b50d1d9253358dda911fd10c5e3c891de9690"
    sha256 cellar: :any_skip_relocation, big_sur:        "12bab4a6f997bd961b1b01c0d37a68f49b50ed5419940dec018dae4837bb5f31"
    sha256 cellar: :any_skip_relocation, catalina:       "109cfe02558a837c81ec22bd9f77a9a7a9d63fa0f61d4dd21d2a3a8622161f74"
    sha256 cellar: :any_skip_relocation, mojave:         "6485a71ec52617ecf4ecca6f435376354877896ba21a6b5d5d3514e6da996d97"
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
