class Autodiff < Formula
  desc "Automatic differentiation made easier for C++"
  homepage "https://autodiff.github.io"
  url "https://github.com/autodiff/autodiff/archive/v0.6.10.tar.gz"
  sha256 "d6bc2f44cab5fd132deabdcb2a9e914b4959660c80a40a2c3f20dde79fc113d9"
  license "MIT"
  head "https://github.com/autodiff/autodiff.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f24e2ec6617f75ac7c2049c9df4bb60eaf3ef831356cb066dbb12294339939d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ce75471c433996d1fdbfee5b19360457da9dca8dccbaaa6b0df07745cb16ab4"
    sha256 cellar: :any_skip_relocation, monterey:       "a1897f55a220644484aa09a67a8faea7b4c87d03c934dd413801428f1977a01f"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d299a936d150f5c42ef16d1978d1c198064d8ceaca125da313af4ea77075e82"
    sha256 cellar: :any_skip_relocation, catalina:       "2a17b8c664379d6ebe4fcd025697900a496fad93674ff1fb3f4dc78372a235e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9ff00439ee2a1b33db57a6bee58c7a263aafcfa083327ac41773a697c8436bb"
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
