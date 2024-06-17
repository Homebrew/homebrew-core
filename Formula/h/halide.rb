class Halide < Formula
  desc "Language for fast, portable data-parallel computation"
  homepage "https://halide-lang.org"
  url "https://github.com/halide/Halide/archive/refs/tags/v17.0.1.tar.gz"
  sha256 "beb18331d9e4b6f69943bcc75fb9d923a250ae689f09f6940a01636243289727"
  license "MIT"
  revision 1
  head "https://github.com/halide/Halide.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "acfb233ba9a4fe0dbf9cc356ce05089e4898e2a704bd042eb63adc834d06ee7f"
    sha256 cellar: :any,                 arm64_ventura:  "255b0a6cee8ff2e5da7911bc7e2d5bd3c4f9ee1b40341b9bafc0babc005bf02c"
    sha256 cellar: :any,                 arm64_monterey: "911f16993b0b0dd7e6663afb595b7f37a8260330ebda522a302931b7ae7b0772"
    sha256 cellar: :any,                 sonoma:         "20ba24f50c8e9ac478b9f8c95a2eea9f14ab969a5705908aa2a926c499a8897f"
    sha256 cellar: :any,                 ventura:        "52ca13bb0b1db321ef034e694197024ba66feffe89c78bb1ba0aa742d6df1825"
    sha256 cellar: :any,                 monterey:       "98510b52e0ca95f63ca49860d123d6b8ecf8ecb51d294bb7505968795bcc80a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd4cc8f18056d83d9ac55a7a3616cfd66ca9495e034a56af7074eceb70a09d5a"
  end

  depends_on "cmake" => :build
  depends_on "pybind11" => :build
  depends_on "flatbuffers"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "llvm@17"
  depends_on "python@3.12"

  fails_with :gcc do
    version "6"
    cause "Requires C++17"
  end

  # Check wabt version in `dependencies/wasm/CMakeLists.txt`.
  # TODO: Ask upstream to support usage of a system-provided wabt.
  # TODO: Do we really need a git checkout here?
  resource "wabt" do
    url "https://github.com/WebAssembly/wabt.git",
        tag:      "1.0.33",
        revision: "963f973469b45969ce198e0c86d3af316790a780"
  end

  def python3
    "python3.12"
  end

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm@17"].opt_lib if DevelopmentTools.clang_build_version >= 1500

    builddir = buildpath/"build"
    (builddir/"_deps/wabt-src").install resource("wabt")

    system "cmake", "-S", ".", "-B", builddir,
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DHalide_INSTALL_PYTHONDIR=#{prefix/Language::Python.site_packages(python3)}",
                    "-DHalide_SHARED_LLVM=ON",
                    "-DPYBIND11_USE_FETCHCONTENT=OFF",
                    "-DFLATBUFFERS_USE_FETCHCONTENT=OFF",
                    *std_cmake_args
    system "cmake", "--build", builddir
    system "cmake", "--install", builddir
  end

  test do
    cp share/"doc/Halide/tutorial/lesson_01_basics.cpp", testpath
    system ENV.cxx, "-std=c++17", "lesson_01_basics.cpp", "-L#{lib}", "-lHalide", "-o", "test"
    assert_match "Success!", shell_output("./test")

    cp share/"doc/Halide_Python/tutorial-python/lesson_01_basics.py", testpath
    assert_match "Success!", shell_output("#{python3} lesson_01_basics.py")
  end
end
