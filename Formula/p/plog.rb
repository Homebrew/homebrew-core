class Plog < Formula
  desc "Portable, simple and extensible C++ logging library"
  homepage "https://github.com/SergiusTheBest/plog"
  url "https://github.com/SergiusTheBest/plog/archive/refs/tags/1.1.9.tar.gz"
  sha256 "058315b9ec9611b659337d4333519ab4783fad3f2f23b1cc7bb84d977ea38055"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9493fc71b411fffb88f8541aa19209ea9a75df89f71370cd1655144fbef8ab78"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9493fc71b411fffb88f8541aa19209ea9a75df89f71370cd1655144fbef8ab78"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9493fc71b411fffb88f8541aa19209ea9a75df89f71370cd1655144fbef8ab78"
    sha256 cellar: :any_skip_relocation, ventura:        "9493fc71b411fffb88f8541aa19209ea9a75df89f71370cd1655144fbef8ab78"
    sha256 cellar: :any_skip_relocation, monterey:       "9493fc71b411fffb88f8541aa19209ea9a75df89f71370cd1655144fbef8ab78"
    sha256 cellar: :any_skip_relocation, big_sur:        "9493fc71b411fffb88f8541aa19209ea9a75df89f71370cd1655144fbef8ab78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "add968eb36e5f301923bc3d3cf3ff85c502137840b5a5016b167722a9ac7df30"
  end

  depends_on "cmake" => [:build, :test]

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.5)
      project(TestPlog)
      find_package(plog REQUIRED)

      add_executable(test_plog test.cpp)
      include_directories(${PLOG_INCLUDE_DIRS})
    EOS

    (testpath/"test.cpp").write <<~EOS
      #include <plog/Log.h> // Step1: include the headers
      #include "plog/Initializers/RollingFileInitializer.h"

      int main()
      {
          plog::init(plog::debug, "Hello.txt"); // Step2: initialize the logger

          // Step3: write log messages using a special macro
          // There are several log macros, use the macro you liked the most

          PLOGD << "Hello log!"; // short macro
          PLOG_DEBUG << "Hello log!"; // long macro
          PLOG(plog::debug) << "Hello log!"; // function-style macro

          // Also you can use LOG_XXX macro but it may clash with other logging libraries
          LOGD << "Hello log!"; // short macro
          LOG_DEBUG << "Hello log!"; // long macro
          LOG(plog::debug) << "Hello log!"; // function-style macro

          return 0;
      }
    EOS

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_BUILD_TYPE=Debug", *std_cmake_args
    system "cmake", "--build", "build", "--target", "test_plog"
    system "build/test_plog"
    assert_match "Hello log!", (testpath/"Hello.txt").read
  end
end
