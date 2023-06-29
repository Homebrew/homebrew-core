class Halide < Formula
  desc "Language for fast, portable data-parallel computation"
  homepage "https://halide-lang.org"
  url "https://github.com/halide/Halide/archive/v16.0.0.tar.gz"
  sha256 "a0cccee762681ea697124b8172dd65595856d0fa5bd4d1af7933046b4a085b04"
  license "MIT"
  head "https://github.com/halide/Halide.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1dc8e72c88d4765ca1a4c4fa0aa587be9d4791c252cb570374e902a2f402086e"
    sha256 cellar: :any,                 arm64_monterey: "d81f24d816d895b0f10755771bfee33a0c03ac895fc1e2a7399849c794eccb37"
    sha256 cellar: :any,                 arm64_big_sur:  "f356585914ef921814333752a006d9e4033163372aa50c65929c6645a344431e"
    sha256 cellar: :any,                 ventura:        "0f5126b08161572979ed23b87a1ce7623ee0971dd7a57f44acaebc76578936a0"
    sha256 cellar: :any,                 monterey:       "95166cdc80500c57799c052f255065b7fb8499c25f5f7a732587c7b8da1563da"
    sha256 cellar: :any,                 big_sur:        "727ee7167d0f2026de4f7ce5654a601e71485c56573cc766593a748b71849b70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ff3882c4b82e3a44a92670c8579b6817447ae304efb6d27c176684e04e9200b"
  end

  depends_on "cmake" => :build
  depends_on "pybind11" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "llvm"
  depends_on "python@3.11"

  fails_with :gcc do
    version "6"
    cause "Requires C++17"
  end

  def python3
    "python3.11"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DHalide_INSTALL_PYTHONDIR=#{prefix/Language::Python.site_packages(python3)}",
                    "-DHalide_SHARED_LLVM=ON",
                    "-DPYBIND11_USE_FETCHCONTENT=OFF",
                    *std_cmake_args
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
