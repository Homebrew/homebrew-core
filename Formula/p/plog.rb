class Plog < Formula
  desc "Portable, simple and extensible C++ logging library"
  homepage "https://github.com/SergiusTheBest/plog"
  url "https://github.com/SergiusTheBest/plog/archive/refs/tags/1.1.11.tar.gz"
  sha256 "d60b8b35f56c7c852b7f00f58cbe9c1c2e9e59566c5b200512d0cdbb6309a7c2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1128d5665015871186eb36b6ad55699345e184c854f510884bce557207d532fc"
  end

  depends_on "cmake" => [:build, :test]

  resource "freertos_kernel" do
    on_linux do
      url "https://github.com/FreeRTOS/FreeRTOS-Kernel/archive/refs/tags/V11.1.0.tar.gz"
      sha256 "0e21928b3bcc4f9bcaf7333fb1c8c0299d97e2ec9e13e3faa2c5a7ac8a3bc573"
    end
  end

  def install
    args = []
    if OS.linux?
      resource("freertos_kernel").stage buildpath/"freertos_kernel"
      args << "-DFETCHCONTENT_SOURCE_DIR_FREERTOS_KERNEL=#{buildpath}/freertos_kernel"
    end
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.5)
      project(TestPlog)
      find_package(plog REQUIRED)

      add_executable(test_plog test.cpp)
      include_directories(${PLOG_INCLUDE_DIRS})
    CMAKE

    (testpath/"test.cpp").write <<~CPP
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
    CPP

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_BUILD_TYPE=Debug", *std_cmake_args
    system "cmake", "--build", "build", "--target", "test_plog"
    system "build/test_plog"
    assert_match "Hello log!", (testpath/"Hello.txt").read
  end
end
