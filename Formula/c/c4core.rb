class C4core < Formula
  desc "C++ utilities"
  homepage "https://github.com/biojppm/c4core"
  url "https://github.com/biojppm/c4core/releases/download/v0.6.0/c4core-0.6.0-src.tgz"
  sha256 "fd0a3e2c39a5985c6699e306ead71e8a73a6ada2577c905734a2a6ba0a61c1b7"
  license all_of: ["MIT", "BSL-1.0"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "214516874ec203bbc26aefa4a3d0619deebf919cb7914ef04a5655e8ad918769"
    sha256 cellar: :any, arm64_sequoia: "7e1ca65706f1d8e07a95ea9b897c6a93592d84407fd0333e453a8d73f056b622"
    sha256 cellar: :any, arm64_sonoma:  "86dda2e496dc32b641864e460cbc42ea3694edcc493e0c26a1ff61b9bcb86ac4"
    sha256 cellar: :any, sonoma:        "b9b589a2523704c42236df1d0df97400cdbc067477247d2bb7522367ea19b8f7"
    sha256 cellar: :any, arm64_linux:   "4987d9a3cc1551650b8a3ffc4d252f582386815d87f4da38064f1836e75cdd07"
    sha256 cellar: :any, x86_64_linux:  "5a6877c90df1d27cb401617fca6adcfaa330bb5c6c99dc53e753c9ab12e803c9"
  end

  depends_on "cmake" => [:build, :test]

  conflicts_with "rapidyaml", because: "both install `c4core` files `include/c4`"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.5)
      project(c4core_test)

      find_package(c4core)

      add_executable(c4core_test test.cpp)
      target_link_libraries(c4core_test c4core::c4core)
    CMAKE

    (testpath/"test.cpp").write <<~CPP
      #include "c4/charconv.hpp" // header file for character conversion utilities
      #include "c4/format.hpp"   // header file for formatting utilities
      #include <iostream>
      #include <string>

      int main() {
          // using c4core to do integer to string conversion
          int number = 42;
          char buf[64];
          c4::substr buf_sub(buf, sizeof(buf));
          size_t num_chars = c4::itoa(buf_sub, number);
          buf[num_chars] = '\0'; // Ensuring the buffer is null-terminated
          std::cout << "The number is: " << buf << std::endl;

          // For formatted output, first format into a buffer, then create a std::string from it
          char format_buf[64];
          snprintf(format_buf, sizeof(format_buf), "Formatted number: %d", number);
          std::string formatted_string = format_buf;
          std::cout << formatted_string << std::endl;

          return 0;
      }
    CPP

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    assert_equal <<~EOS, shell_output("./build/c4core_test")
      The number is: 42
      Formatted number: 42
    EOS
  end
end
