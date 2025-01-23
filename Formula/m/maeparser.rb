class Maeparser < Formula
  desc "Maestro file parser"
  homepage "https://github.com/schrodinger/maeparser"
  url "https://github.com/schrodinger/maeparser/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "a8d80f67d1b9be6e23b9651cb747f4a3200132e7d878a285119c86bf44568e36"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f6b3e9889ac81328137f42c232abc8ed084f6fccd7f8f9d228925e52d17734b0"
    sha256 cellar: :any,                 arm64_sonoma:  "d3e926ea865bb4929a1a6b04ac4ec013725fa85cae99b4fdf2d7620d3f2002bd"
    sha256 cellar: :any,                 arm64_ventura: "11364b3ab0837b8e2b1639cf983efce227cee7c03736dd5b0686a47e92a22374"
    sha256 cellar: :any,                 sonoma:        "3f4b0aff09fd2fc3024bccd8032bde18ba11aaa87fb3bb6ccd1bf7427a6239ad"
    sha256 cellar: :any,                 ventura:       "b3e8cd570f15d6378649b8995549de4bd75287c7f7ffefeffcfa431aaa08bac2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12d7caa35b65a79899391609904857c9910a120c35c520dfcac562a22c9cf88f"
  end

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DMAEPARSER_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "test/MainTestSuite.cpp", "test/UsageDemo.cpp", "test/test2.maegz"
  end

  test do
    cp pkgshare.children, testpath
    system ENV.cxx, "-std=c++11", "MainTestSuite.cpp", "UsageDemo.cpp", "-o", "test",
                    "-DTEST_SAMPLES_PATH=\"#{testpath}\"", "-DBOOST_ALL_DYN_LINK",
                    "-I#{include}/maeparser", "-L#{lib}", "-lmaeparser",
                    "-L#{Formula["boost"].opt_lib}", "-lboost_filesystem", "-lboost_unit_test_framework"
    system "./test"
  end
end
