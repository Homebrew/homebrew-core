class Halide < Formula
  desc "Language for fast, portable data-parallel computation"
  homepage "https://halide-lang.org"
  url "https://github.com/halide/Halide/archive/refs/tags/v19.0.0.tar.gz"
  sha256 "83bae1f0e24dc44d9d85014d5cd0474df2dd03975680894ce3fafd6e97dffee2"
  license "MIT"
  head "https://github.com/halide/Halide.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "63e0a77f37e9db89b85ee69af56a4c48af67f4131acc439d103c834c973b696e"
    sha256 cellar: :any,                 arm64_sonoma:  "95a7b448f9ed4e23d48603ae2a63b92e5d0cf4729ee5e3bda4128234d3861baa"
    sha256 cellar: :any,                 arm64_ventura: "57bae5cff5b521cc42a80f786411acf9cadc049ab5f7100d71e429c8986be6f4"
    sha256 cellar: :any,                 sonoma:        "51ffd96b6e358f9e53ad81f0d3e9987c72d2ba2c19f85563fcd334baf0f25cf0"
    sha256 cellar: :any,                 ventura:       "53888029c3c797b57577bb390dbcc34a4fe909b6aac219c81be9f55555764d3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a0bf8651e7a1c027c38776e0df09d4117156145efbacbc0fbbf00e0806cea21"
  end

  depends_on "cmake" => :build
  depends_on "pybind11" => :build
  depends_on "flatbuffers"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "lld"
  depends_on "llvm"
  depends_on "python@3.13"
  depends_on "wabt"

  on_macos do
    depends_on "openssl@3"
  end

  def python3
    "python3.13"
  end

  def install
    site_packages = prefix/Language::Python.site_packages(python3)
    rpaths = [rpath, rpath(source: site_packages/"halide")]
    args = [
      "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}",
      "-DHalide_INSTALL_PYTHONDIR=#{site_packages}/halide",
      "-DHalide_LLVM_SHARED_LIBS=ON",
      "-DHalide_USE_FETCHCONTENT=OFF",
      "-DWITH_TESTS=NO",
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    cp share/"doc/Halide/tutorial/lesson_01_basics.cpp", testpath
    system ENV.cxx, "-std=c++17", "lesson_01_basics.cpp", "-L#{lib}", "-lHalide", "-o", "test"
    assert_match "Success!", shell_output("./test")

    cp share/"doc/Halide_Python/tutorial-python/lesson_01_basics.py", testpath
    assert_match "Success!", shell_output("#{python3} lesson_01_basics.py")
  end
end
