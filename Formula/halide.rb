class Halide < Formula
  desc "Language for fast, portable data-parallel computation"
  homepage "https://halide-lang.org"
  url "https://github.com/halide/Halide/archive/v14.0.0.tar.gz"
  sha256 "f9fc9765217cbd10e3a3e3883a60fc8f2dbbeaac634b45c789577a8a87999a01"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7f338eeb5f667a39bf8c7b9e31975ead7efd0b93a521376f9a8b8ea01f15a2e8"
    sha256 cellar: :any,                 arm64_big_sur:  "50d8081722a01e2e3a1d060b0ef154c910bd40909231af5af55cef38a5a4a07d"
    sha256 cellar: :any,                 monterey:       "7b73ae689dd71d54f37bfa24d1eba92870895d5331536cc1824e94a9b18daf0e"
    sha256 cellar: :any,                 big_sur:        "ecafe1ae5a96849e3f62a7085b1a99a6dd1ed5a5ee33413a543373ff9004741f"
    sha256 cellar: :any,                 catalina:       "0f5058e9839b7ea04e2db363763ec40f77f4e16629571655f1e2d57e07594ba8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0c94a36951baaddbc68ef4bfd15d363ce335009e61b960932b545491d7e8336"
  end

  depends_on "cmake" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "llvm"
  depends_on "python@3.10"

  fails_with gcc: "5" # LLVM is built with Homebrew GCC

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}", "-DHalide_SHARED_LLVM=ON"
      system "make"
      system "make", "install"
    end
  end

  test do
    cp share/"doc/Halide/tutorial/lesson_01_basics.cpp", testpath
    system ENV.cxx, "-std=c++17", "lesson_01_basics.cpp", "-L#{lib}", "-lHalide", "-o", "test"
    assert_match "Success!", shell_output("./test")
  end
end
