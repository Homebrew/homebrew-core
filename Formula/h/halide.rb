class Halide < Formula
  desc "Language for fast, portable data-parallel computation"
  homepage "https://halide-lang.org"
  url "https://github.com/halide/Halide/archive/refs/tags/v21.0.0.tar.gz"
  sha256 "aa6b6f5e89709ca6bc754ce72b8b13b2abce0d6b001cb2516b1c6f518f910141"
  license "MIT"
  revision 1
  head "https://github.com/halide/Halide.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2971971113569192c7c113fc28e6e403037b5678aa1e18a4fdadbf198da94cd1"
    sha256 cellar: :any,                 arm64_sequoia: "40779827ae67ed29c0cf27f0837e6a6d158d1352d3eee19f81d80cc24f2c6256"
    sha256 cellar: :any,                 arm64_sonoma:  "cbc3e5f59f48c7360f53a841c14f9c90b364760be44eada0da13851053f0946f"
    sha256 cellar: :any,                 sonoma:        "3d797396c4285b0123b7498d8fa794984c135b9e1b7985e7706ed927ec1fd4a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c69185c4c47845f19b7abc2be16eda2dfeba014a8ffcc357afce2ba44960339"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6731e04b241447c0e900d54b50d3d69429250d46b2384fd3a9601a520555a33e"
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

  def python3
    "python3.14"
  end

  # Backport support for wabt 1.0.39
  patch do
    url "https://github.com/halide/Halide/commit/7d7f0b4422594296fed1d561a43dc262d163d2b8.patch?full_index=1"
    sha256 "6b861e585ce4d71aec53b225562e078086ee310e8c6e7a052bf3fd53f03322ab"
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
