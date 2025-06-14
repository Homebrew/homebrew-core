class Maeparser < Formula
  desc "Maestro file parser"
  homepage "https://github.com/schrodinger/maeparser"
  url "https://github.com/schrodinger/maeparser/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "78e7571a779ea4952e752ecef57c62fb26463947e29ef7f4b31b11988d88ca07"
  license "MIT"
  head "https://github.com/schrodinger/maeparser.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fbcc6b87403bf3ee4ceae13512659743cc3393caececa0f7837a6848e60237b3"
    sha256 cellar: :any,                 arm64_sonoma:  "65bea7147115cac9532e7a76903519dbe14cf0b3e2059ebb1de6f37932d5c54a"
    sha256 cellar: :any,                 arm64_ventura: "8d9cbbfa90e1802ae8c9960a71c1e5b14e1023f3918bf6865db384492ed7bb37"
    sha256 cellar: :any,                 sonoma:        "10abbb0c4240afefd27f6e2d5951252f0e94ca71b02a3dc9725717516c92000c"
    sha256 cellar: :any,                 ventura:       "bb78ef2275ad44ab797f93ffc31433123cbd81e3e546c3c506978e51172b687f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d7fd3d7331c9db8b8efa85714704ac4990c137c651626c54cbc1a6aca1ebda3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04b61f362ce5bc019f4a75567236c2446dcc9ff33bf1945f3f90e3064244722b"
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
