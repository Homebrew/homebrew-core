class Autodiff < Formula
  desc "Automatic differentiation made easier for C++"
  homepage "https://autodiff.github.io"
  url "https://github.com/autodiff/autodiff/archive/v0.6.10.tar.gz"
  sha256 "d6bc2f44cab5fd132deabdcb2a9e914b4959660c80a40a2c3f20dde79fc113d9"
  license "MIT"
  head "https://github.com/autodiff/autodiff.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3eb333cfe494e7260d6da6c944f028c99d1b8d5140bd542a9246788e6126613"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a27b9f0ad11919704922f82b91dccedfb69a2b259d10ba86d6d26ad4754017de"
    sha256 cellar: :any_skip_relocation, monterey:       "bc9252b336e387376e06291a736943e6d6b9853bf1ffd256170a70b0a5065b03"
    sha256 cellar: :any_skip_relocation, big_sur:        "a8d3200c31c308b12edc9cb6f61287143356de4678ff07305fdf64e6a72c65d7"
    sha256 cellar: :any_skip_relocation, catalina:       "c8db7d085b795914ae9b97fb50c233ef72802f7788ea5f0720a4a607729e1c7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c730f33189940c90c359a864ea7dd1c0320ab6952b80f32d5fbee8fa4b043cf"
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
