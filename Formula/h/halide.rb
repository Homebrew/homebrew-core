class Halide < Formula
  desc "Language for fast, portable data-parallel computation"
  homepage "https://halide-lang.org"
  url "https://github.com/halide/Halide/archive/refs/tags/v22.1.0.tar.gz"
  sha256 "35b59f91be6189645abf33078b1954740a434d97aaeaeaf5f15d162d86b74f6e"
  license "MIT"
  head "https://github.com/halide/Halide.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:\.post\d+)?)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4b68d3644ef118b686d0f998652dbbf8efe2fca832dbb6fc273422a2e65bba8b"
    sha256 cellar: :any, arm64_tahoe:       "7ea4d3d40a0104a7517436cf9dd9d4cf9171789cc15c4e49eabc50782b427964"
    sha256 cellar: :any, arm64_sequoia:     "4f57547b5ca43b2f63767b40a5607fa76926f8e6bcdeb7564d90cf066a11d8df"
    sha256 cellar: :any, arm64_linux:       "a49d99d5630a087cac32cfa2e10b289e78c1956d37238675201ea0c3e0c3f131"
    sha256 cellar: :any, x86_64_linux:      "bda661c3abef669234824acd20b17338fc484199690cdde414c81cbe0cb60fad"
  end

  depends_on "cmake" => :build
  depends_on "flatbuffers" => :build
  depends_on "nanobind" => :build
  depends_on "ninja" => :build
  depends_on "python@3.15" => [:build, :test]
  depends_on "lld"
  depends_on "llvm"
  depends_on "wabt" => :no_linkage

  deny_network_access!

  def install
    llvm = deps.map(&:name).find { |f| f.match?(/^llvm(@\d+(\.\d+)*)?$/) }
    site_packages = prefix/Language::Python.site_packages(python3)
    rpaths = [rpath, rpath(source: site_packages/"halide")]
    rpaths << formula_opt_lib(llvm).to_s if OS.linux?
    args = [
      "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}",
      "-DHalide_INSTALL_PYTHONDIR=#{site_packages}/halide",
      "-DHalide_LLVM_SHARED_LIBS=ON",
      "-DWITH_TESTS=OFF",
    ]
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

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
