class Halide < Formula
  desc "Language for fast, portable data-parallel computation"
  homepage "https://halide-lang.org"
  license "MIT"
  revision 1
  head "https://github.com/halide/Halide.git", branch: "main"

  stable do
    url "https://github.com/halide/Halide/archive/refs/tags/v21.0.0.tar.gz"
    sha256 "aa6b6f5e89709ca6bc754ce72b8b13b2abce0d6b001cb2516b1c6f518f910141"

    # Backport support for wabt 1.0.39
    patch do
      url "https://github.com/halide/Halide/commit/7d7f0b4422594296fed1d561a43dc262d163d2b8.patch?full_index=1"
      sha256 "6b861e585ce4d71aec53b225562e078086ee310e8c6e7a052bf3fd53f03322ab"
      type :backport
      resolves "https://github.com/halide/Halide/pull/8923"
    end

    # Backport dropping the exact wabt version to build with wabt 1.0.41
    patch do
      url "https://github.com/halide/Halide/commit/6a7ed977f0e03dc812b8ae4ef43654178d651c46.patch?full_index=1"
      sha256 "63232c844394cbaff3137f2a9e144579d4ad0af150ed1cf0e784edcc3d07b503"
      type :backport
      resolves "https://github.com/halide/Halide/pull/9016"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "1de3b79eb30e6687c17b62174ea9e17bdf0d5f7a2dcb021144cdc584f58753be"
    sha256 cellar: :any, arm64_tahoe:       "4037cdf06844aa825899743cf9580881f6e6bf90cc45c90720577f6a520053e6"
    sha256 cellar: :any, arm64_sequoia:     "99e3feaaaf8a7d5494771880d9fbf987c7e9f3d67c803f65eac753e0a7e86eed"
    sha256 cellar: :any, arm64_linux:       "a13a8eb7536c3198136093eabd8791d13ae098c6d496e141ac392691b8b6ab97"
    sha256 cellar: :any, x86_64_linux:      "ccca9e28c9adaa58a204284f0322b138e8afbf5e4cbced80f98fe319ca118cb3"
  end

  depends_on "cmake" => :build
  depends_on "pybind11" => :build
  depends_on "flatbuffers"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "lld@21"
  depends_on "llvm@21"
  depends_on "python@3.14"
  depends_on "wabt"

  on_macos do
    depends_on "openssl@3"
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
