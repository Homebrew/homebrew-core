class Autodiff < Formula
  desc "Automatic differentiation made easier for C++"
  homepage "https://autodiff.github.io"
  url "https://github.com/autodiff/autodiff/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "86f68aabdae1eed214bfbf0ddaa182c78ea1bb99e4df404efb7b94d30e06b744"
  license "MIT"
  head "https://github.com/autodiff/autodiff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fec99862d8cfea1ebb33b90857ff030a73c18f8c36ca2e89d2b4fbb721bb1a1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39ea5d4afbd986d79a6feb28f96d212017fd0692126e1c8a53e1b2f81936e7a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e73143ccda9035083e5768291d983f80bbfc557c62bb0c7bf6494d27526bac4a"
    sha256 cellar: :any_skip_relocation, sonoma:         "40127879f9beef77999fbf3d200b2dccc16a358d79c62328ec29466c354110ce"
    sha256 cellar: :any_skip_relocation, ventura:        "92ae133082b3de3364bef6e56f6e24059876ee3aacc7c21ba5bb173346bb8db0"
    sha256 cellar: :any_skip_relocation, monterey:       "107eefad53125ecb0f593acbdca6ef1e604bfe0b8e5067ad7de0e674164531d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2236156e6ab762361a509e6c1010ffa90c10fa565c55bb5446ade9490eb5d4d4"
  end

  depends_on "cmake" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "eigen"
  depends_on "pybind11"

  fails_with gcc: "5"

  def python3
    "python3.12"
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
