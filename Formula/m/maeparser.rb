class Maeparser < Formula
  desc "Maestro file parser"
  homepage "https://github.com/schrodinger/maeparser"
  url "https://github.com/schrodinger/maeparser/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "78e7571a779ea4952e752ecef57c62fb26463947e29ef7f4b31b11988d88ca07"
  license "MIT"
  revision 3
  head "https://github.com/schrodinger/maeparser.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9016cea0792cb1dac70619b30aa6f00ddd5e698a54e55e628d77b2395bb63457"
    sha256 cellar: :any, arm64_sequoia: "559fa0910133740fab4e00c566397636da7c801f7dec9c49df04f93ac89ccfcc"
    sha256 cellar: :any, arm64_sonoma:  "4c64742f5685ca7108f58144fce791b3084fea5ffda72c4daddb4c8653e2b5e7"
    sha256 cellar: :any, sonoma:        "97f849072e73cfac704cbf41a790e2a7008602d42c016458012568ad9efe5f86"
    sha256 cellar: :any, arm64_linux:   "bcb3ac9183f0bcc919674f10f866cd68e9a4327493ce5997a6911b92e486d4cb"
    sha256 cellar: :any, x86_64_linux:  "0a371a7ed3253e9a11fa3b7f0037c8b432ab2809e0a127a8309f0a90ac41c622"
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
                    "-L#{formula_opt_lib("boost")}", "-lboost_filesystem", "-lboost_unit_test_framework"
    system "./test"
  end
end
