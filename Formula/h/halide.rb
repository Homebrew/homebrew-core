class Halide < Formula
  desc "Language for fast, portable data-parallel computation"
  homepage "https://halide-lang.org"
  url "https://github.com/halide/Halide/archive/refs/tags/v18.0.0.tar.gz"
  sha256 "1176b42a3e2374ab38555d9316c78e39b157044b5a8e765c748bf3afd2edb351"
  license "MIT"
  head "https://github.com/halide/Halide.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6b2031a500ff63249751eb8725c9fa6c210ecf153bdc804457fa283bb46202de"
    sha256 cellar: :any,                 arm64_ventura:  "037f742560f3417064e29caf7ebf6357fb26a3f4fed5b29e03ffb3eea9ff3fce"
    sha256 cellar: :any,                 arm64_monterey: "7e710e9a3c2220c90378e70989135cba62f9825c636418d61091b4abd02b9c68"
    sha256 cellar: :any,                 sonoma:         "48adc9932630c4ee63b8b6e5feecadd68facf79946a899401988fe6bfe2a0033"
    sha256 cellar: :any,                 ventura:        "87b1adb8078cd4a56bc1be2db7bad8d750a69bc2a5a884ea7bfdc11314b93827"
    sha256 cellar: :any,                 monterey:       "f748e6696e228dac1329f3404d7c74d727ce773fd3d1266b856c658630bd9f00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d64368c6dbfc946f2d471139666b3fe0eadfcc49d8b2eaaadd5f52465ef91f8b"
  end

  depends_on "cmake" => :build
  depends_on "pybind11" => :build
  depends_on "flatbuffers"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "llvm"
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
    builddir = buildpath/"build"
    (builddir/"_deps/wabt-src").install resource("wabt")

    system "cmake", "-S", ".", "-B", builddir,
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DHalide_INSTALL_PYTHONDIR=#{prefix/Language::Python.site_packages(python3)}",
                    "-DHalide_SHARED_LLVM=ON",
                    "-DPYBIND11_USE_FETCHCONTENT=OFF",
                    "-DFLATBUFFERS_USE_FETCHCONTENT=OFF",
                    "-DFETCHCONTENT_SOURCE_DIR_WABT=#{builddir}/_deps/wabt-src",
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
