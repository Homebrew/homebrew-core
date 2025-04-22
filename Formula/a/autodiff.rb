class Autodiff < Formula
  desc "Automatic differentiation made easier for C++"
  homepage "https://autodiff.github.io"
  url "https://github.com/autodiff/autodiff/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "86f68aabdae1eed214bfbf0ddaa182c78ea1bb99e4df404efb7b94d30e06b744"
  license "MIT"
  head "https://github.com/autodiff/autodiff.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e35fef20edd7f2dc9b18d7f1a7f37d7cde1bb6d9154d7a2992c283baf111855b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ffd7fdaf5ddf5ed5729344e6a1e8065a71aa29ab6c2038d51d0e2c0e3655c0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "11282c10e5cee0cf915621a24c511a87a5721ceef2f659e2adbdd458c787bf74"
    sha256 cellar: :any_skip_relocation, sonoma:        "2534cac50c7135f77ee140e68802bb0751cd40e5e6f6950ba11115b18eb2b755"
    sha256 cellar: :any_skip_relocation, ventura:       "70ba0bf70fe3212bcdf215f1210b44b3e093da1eb06140a397335d3cfd37ae14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8200c3f1ef1a2bfe0f357b02ba8d63de6d89094623729b5e33ef7affd2f1d342"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "123363de8b59cbc789b655d7ed2fca5acb59dc9d39b5690df5d874a7e8bba85c"
  end

  depends_on "cmake" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "eigen"
  depends_on "pybind11"

  def python3
    "python3.13"
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
                    "-I#{include}", "-I#{Formula["eigen"].opt_include}/eigen3", "-o", "forward"
    system ENV.cxx, pkgshare/"test/reverse.cpp", "--std=c++17",
                    "-I#{include}", "-I#{Formula["eigen"].opt_include}/eigen3", "-o", "reverse"
    assert_match "u = 8.19315\ndu/dx = 5.25\n", shell_output(testpath/"forward")
    assert_match "u = 8.19315\nux = 5.25\n", shell_output(testpath/"reverse")
    system python3, "-c", "import autodiff"
  end
end
