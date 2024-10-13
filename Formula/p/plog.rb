class Plog < Formula
  desc "Portable, simple and extensible C++ logging library"
  homepage "https://github.com/SergiusTheBest/plog"
  url "https://github.com/SergiusTheBest/plog/archive/refs/tags/1.1.10.tar.gz"
  sha256 "55a090fc2b46ab44d0dde562a91fe5fc15445a3caedfaedda89fe3925da4705a"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "97760bb532e44bf5f1d01856ec41448c1ba1f092b5abacaa5338c9a27be6567a"
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
