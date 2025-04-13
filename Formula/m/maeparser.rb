class Maeparser < Formula
  desc "Maestro file parser"
  homepage "https://github.com/schrodinger/maeparser"
  url "https://github.com/schrodinger/maeparser/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "431ae029957534324b59eb3974486f3cad97d06e9bacd88ec94dc598046dfcd3"
  license "MIT"
  head "https://github.com/schrodinger/maeparser.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ea15917958a53a0d5b2f879974be4f56a9ecdb646754db551e069f35855728c5"
    sha256 cellar: :any,                 arm64_sonoma:  "fba864563b917677bf0f8f337b25cb3d6811ffa9e9110360c856244aed07c3fe"
    sha256 cellar: :any,                 arm64_ventura: "a6a354255cb39bfa96a940eaf320056460289fb3492d68a94388071a3abe5075"
    sha256 cellar: :any,                 sonoma:        "d957171267fb9a809a0ffce8bd85465275ef0d469f829746a3bdb69882f3d10b"
    sha256 cellar: :any,                 ventura:       "ec3fc1675b563d4ac1aa2ba2c07e4e8018772c76e1f0a9ff7311c161527c7cbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a9ddd61917e03beb195b00b5ed0a5a222d1c1a7da25d383f1115a7302d10ce0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d494b9e7b808a3b5cdc4df687c0c72c2a7b414bec672d6b66d713f5a228cff2b"
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
