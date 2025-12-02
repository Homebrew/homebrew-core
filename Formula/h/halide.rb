class Halide < Formula
  desc "Language for fast, portable data-parallel computation"
  homepage "https://halide-lang.org"
  url "https://github.com/halide/Halide/archive/refs/tags/v21.0.0.tar.gz"
  sha256 "aa6b6f5e89709ca6bc754ce72b8b13b2abce0d6b001cb2516b1c6f518f910141"
  license "MIT"
  head "https://github.com/halide/Halide.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "530feb171d27ce1e4ee4a388dddc4109cbea2b7a8949754c87be3834dd825e1e"
    sha256 cellar: :any,                 arm64_sequoia: "513484cc94e98264a6a8882aace19c70c507819e4bc9dd224501949374e23abc"
    sha256 cellar: :any,                 arm64_sonoma:  "06ddd4f412b445c65dee2209477fec0fbc8951c14d35f4198c2cf81ef7ff9496"
    sha256 cellar: :any,                 sonoma:        "f7e23e2dc174cf2746b91ea41c05ae816a4267bd6ec35f7a420f439707ad3e2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "649331aedc479125eeb13f911db36017c1e17af2f7ee4d75d707c5a4e43f4f79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63df6d5bc9cdf9da2359017aabda30d4ce68d95b2aeb2b79fe099ffe5adbbcdd"
  end

  depends_on "cmake" => :build
  depends_on "pybind11" => :build
  depends_on "flatbuffers"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "lld"
  depends_on "llvm"
  depends_on "python@3.14"
  depends_on "wabt"

  on_macos do
    depends_on "openssl@3"
  end

  def python3
    "python3.14"
  end

  def install
    # Disable SVE feature as broken: https://github.com/halide/Halide/issues/8529
    inreplace "src/Target.cpp", /^\s*initial_features.push_back\(Target::SVE/, "// \\0"

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
