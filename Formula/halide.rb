class Halide < Formula
  desc "Language for fast, portable data-parallel computation"
  homepage "https://halide-lang.org"
  license "MIT"
  revision 4

  # Remove `stable` when we switch to `llvm`.
  stable do
    url "https://github.com/halide/Halide/archive/v14.0.0.tar.gz"
    sha256 "f9fc9765217cbd10e3a3e3883a60fc8f2dbbeaac634b45c789577a8a87999a01"
    depends_on "llvm@14"
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "bbc21a619130e7cb70c69f8d94f4dd3a0e5009facb506a91178f18b3afc7badc"
    sha256 cellar: :any,                 arm64_monterey: "ffca8fbcbc293419fdc272e18ba4ca418912c854ea9b0c9baabbaa1c0726e898"
    sha256 cellar: :any,                 arm64_big_sur:  "5be685201da294126f82ea8e8aceeac5d0fe040b163e583f707e64d49f832b82"
    sha256 cellar: :any,                 ventura:        "d31a9d7316b783747ca120ae9c59fc89f2ad29f0bbb8eb22e11f54c7d9cccc96"
    sha256 cellar: :any,                 monterey:       "255337c037fd455f2bf51b9e796e9c265e29adae211f9d61416b0b2e2514a6fa"
    sha256 cellar: :any,                 big_sur:        "808ad8f98edba45149a79752c6500bc47b8e8d00895a4f0d467ffb6b2f5746c3"
    sha256 cellar: :any,                 catalina:       "29f0f95e86579622cd74411b4d07d0629c17cb2bf74fdff9a7a913857b7a3e33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73d56ba4ab967050852357cb08f1625e9956134aeeb86abdd070c02bf1d27469"
  end

  head do
    url "https://github.com/halide/Halide.git", branch: "main"
    depends_on "llvm"
  end

  depends_on "cmake" => :build
  depends_on "pybind11" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
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

    cp share/"doc/Halide/tutorial-python/lesson_01_basics.py", testpath
    assert_match "Success!", shell_output("#{python3} lesson_01_basics.py")
  end
end
