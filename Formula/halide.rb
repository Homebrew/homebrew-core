class Halide < Formula
  desc "Language for fast, portable data-parallel computation"
  homepage "https://halide-lang.org"
  url "https://github.com/halide/Halide/archive/v13.0.1.tar.gz"
  sha256 "8d4b0ad622ef0ff9e28770cd950baf45a055d1229131be44f8e6333a548183f9"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "e23c255e366cfe5f8b2799e8f445e850fe8353b16fd04e8d666867e9b78b76b6"
    sha256 cellar: :any, arm64_big_sur:  "e1cccd883d7210fbc6142bf2a7d3bbee38a6f1674df4b793caf7eb144a873db2"
    sha256 cellar: :any, monterey:       "cd6c353ad562c8e9180ac1d6f79db39906aca67756fb58d1a92fd59e9487120c"
    sha256 cellar: :any, big_sur:        "5a1cb256d2c812126a07bb8c20d0df5c97ddcf0ef2195808731dd595c64e898e"
    sha256 cellar: :any, catalina:       "1d81ccfc6c7c410c0e307abd6a9de17ecb20234983621731491befe65e19b5e1"
  end

  depends_on "cmake" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "llvm"
  depends_on "python@3.10"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DHalide_SHARED_LLVM=ON"
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
