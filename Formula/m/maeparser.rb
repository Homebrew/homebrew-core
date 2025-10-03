class Maeparser < Formula
  desc "Maestro file parser"
  homepage "https://github.com/schrodinger/maeparser"
  url "https://github.com/schrodinger/maeparser/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "78e7571a779ea4952e752ecef57c62fb26463947e29ef7f4b31b11988d88ca07"
  license "MIT"
  revision 1
  head "https://github.com/schrodinger/maeparser.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "54c5bcd42d569b26d7e0ce27848d97bf61aac32238fd0e49f240374c74cbc854"
    sha256 cellar: :any,                 arm64_sequoia: "c0d9db6f10daed3fc6b771924f2e479468fb01e0e9052aa126fe0a3a2ec45688"
    sha256 cellar: :any,                 arm64_sonoma:  "cc29caec6af9758916014f44a462d949b05b451709e5c77574187415c03daba5"
    sha256 cellar: :any,                 arm64_ventura: "465ec71b1618c4c650aaf44b30de39acda2f156652deac0e8961fd02efe64fb7"
    sha256 cellar: :any,                 sonoma:        "8e78db80f19badb63e39b407437e2ffe56b37a29f27257b359e67862a34f803b"
    sha256 cellar: :any,                 ventura:       "c98342065d18d6e1c4040975a8ca4bb911fb0a34b58f67c70f641e271a06d5e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9a5c6cfa985befb79739131b65496d5f6bfdead69ed569903168a6a0950a5bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c50f7c93b5fb8354aee48e6952bc1df0170a3a8a1a6911a0582ad9c8091d097a"
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
