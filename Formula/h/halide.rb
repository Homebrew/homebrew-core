class Halide < Formula
  desc "Language for fast, portable data-parallel computation"
  homepage "https://halide-lang.org"
  license "MIT"
  revision 1

  stable do
    url "https://github.com/halide/Halide/archive/refs/tags/v19.0.0.tar.gz"
    sha256 "83bae1f0e24dc44d9d85014d5cd0474df2dd03975680894ce3fafd6e97dffee2"

    depends_on "lld@19"
    depends_on "llvm@19" # TODO: Use `lld`/`llvm` in both stable and head in Halide 20
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "33f39347076af5498e35bed325acfb3f3251de6efb4d54c72380901a3524ec70"
    sha256 cellar: :any,                 arm64_sonoma:  "5fde8b88d62f8e6320f235828f0e81a91c021c1854688edfdb2203da69701a82"
    sha256 cellar: :any,                 arm64_ventura: "14d6bd1d3b21ddd8c2048fb026c0602be863df3126f686e9e830ff0a475ccd9f"
    sha256 cellar: :any,                 sonoma:        "aae907b9c881d5a750264f333ba2f3991fbe95c8d3dd50e6b2246fdbe0b37665"
    sha256 cellar: :any,                 ventura:       "25f68206d87d7f26f557115db0f87686df2d2d378e619e0fd692d61c9333884a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa6fe703b19d08cfee1366d5366fc1f5a9e93286566a91634007fa3191410417"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "559910d964d788f02580e34bb3483e083f4a292cd9cfb3ee52ee8d6fe0d76c24"
  end

  head do
    url "https://github.com/halide/Halide.git", branch: "main"

    depends_on "lld"
    depends_on "llvm"
  end

  depends_on "cmake" => :build
  depends_on "pybind11" => :build
  depends_on "flatbuffers"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "python@3.13"
  depends_on "wabt"

  on_macos do
    depends_on "openssl@3"
  end

  def python3
    "python3.13"
  end

  def install
    llvm = deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+(\.\d+)*)?$/) }
    site_packages = prefix/Language::Python.site_packages(python3)
    rpaths = [rpath, rpath(source: site_packages/"halide")]
    rpaths << llvm.opt_lib.to_s if OS.linux?
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
