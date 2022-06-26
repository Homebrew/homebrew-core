class Halide < Formula
  desc "Language for fast, portable data-parallel computation"
  homepage "https://halide-lang.org"
  url "https://github.com/halide/Halide/archive/v14.0.0.tar.gz"
  sha256 "f9fc9765217cbd10e3a3e3883a60fc8f2dbbeaac634b45c789577a8a87999a01"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e1ba8d1d6232fd52c98664b9e307aa0f0ba0623ec3a3a4ead0d43b028499d3db"
    sha256 cellar: :any,                 arm64_big_sur:  "f927bd59f1abcf1fd3034f04fe6cff538241bfe3a0975248578ed9e47ba7499c"
    sha256 cellar: :any,                 monterey:       "14c4ba34f34b0261121c8d4416f685f5dc67321dd810d30c3d56c1a25b16167a"
    sha256 cellar: :any,                 big_sur:        "4cbbc5c24273b2cc7b3b4d830ad195b9d8fdc745919e16f166ac2452aff651e2"
    sha256 cellar: :any,                 catalina:       "490da68c6f73b829277d459ea7705b66415e9a50dd48d09b43f55f5d2e9c26ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd52a51fc41dfe0184dbf1cbfdf0dfad45c1071ed0a71fb97e2c792536f6e1fe"
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
