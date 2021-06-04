class Halide < Formula
  desc "Language for fast, portable data-parallel computation"
  homepage "https://halide-lang.org"
  url "https://github.com/halide/Halide/archive/v12.0.1.tar.gz"
  sha256 "17f7a470c3fcf77205fdcd9d06257f17c1c1a3cda4b8023f56cec160e80bd519"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "9d2e07f8d238359c6125594da52bb522cf137586fab3a482697430d89f4a5dcf"
    sha256 cellar: :any, big_sur:       "ef1d1441c627a718f1a82e2a2f1bd3ba95e8a49e6d9109cd4028c7ef1b67f256"
    sha256 cellar: :any, catalina:      "82a4041a0628948f8dbd66215496648973d8080edf8e6ec0dc77da82e4e323a7"
    sha256 cellar: :any, mojave:        "3e5702a5fef2471aba848b8a6d77b99c3923ec52fe8eb124370d034c88d6afa1"
  end

  depends_on "cmake" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "llvm"
  depends_on "python@3.9"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DHalide_SHARED_LLVM=ON"
      system "make"
      system "make", "install"
    end
  end

  test do
    cp share/"tutorial/lesson_01_basics.cpp", testpath
    system ENV.cxx, "-std=c++11", "lesson_01_basics.cpp", "-L#{lib}", "-lHalide", "-o", "test"
    assert_match "Success!", shell_output("./test")
  end
end
