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
    sha256 cellar: :any,                 arm64_tahoe:   "0354fcb55ed8b27a8a7ade125158fd1e008d9f4b0d9583b70e8e4123c24ba5f2"
    sha256 cellar: :any,                 arm64_sequoia: "7c2eb6c3b3f69dff79990ad1171129aedfef3ab1905b7f067e3e5b1d3ac5ee5f"
    sha256 cellar: :any,                 arm64_sonoma:  "e03581effd20bf29fcf62bb80be357422643ef8d228f164100befcedd1f58a63"
    sha256 cellar: :any,                 sonoma:        "a76b190fcc4e9031b0cdb86ce4967d1e9def5b10108516502372449d4130f6ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "528e90e57a8d44919965df10cc4148038e4503de75275a670b79f0a19a13371b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0d5f48b4535843002cb9c5b292f22607b6fce2c34822ca559684c23aa4f7ccf"
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
