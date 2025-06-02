class Maeparser < Formula
  desc "Maestro file parser"
  homepage "https://github.com/schrodinger/maeparser"
  url "https://github.com/schrodinger/maeparser/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "431ae029957534324b59eb3974486f3cad97d06e9bacd88ec94dc598046dfcd3"
  license "MIT"
  revision 1
  head "https://github.com/schrodinger/maeparser.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4c70a47373e7c2e0e640fa52dc2a8d0dc58c420f176fa47f2279d5aee38e15a8"
    sha256 cellar: :any,                 arm64_sonoma:  "f9d519ae0b51e2f22cbfa6c133bb3dc43b1f42bba3f6996edbe218665ce7894e"
    sha256 cellar: :any,                 arm64_ventura: "1f9189fef43fd479e43c02abd49c135a0010fb41c0301e878a3955ef0d638d4c"
    sha256 cellar: :any,                 sonoma:        "6abfa8f7ca248db12f5048cc9739d6e4c04a957289ab1f0d1194dfc8ed3b7fe0"
    sha256 cellar: :any,                 ventura:       "3e5456a0d0e57249fb9e48f547ebac4ba83dd7ce457837fe18c8f80c4d23bbac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff0a8d3ddf905b3fd9f516348ae97d49fb470170fa90cd110c9ca70d0d7be464"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41c46db410204afb11ff5c5e3bc29fb3fa148003d5b21619d4576db390e981d1"
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
