class C4core < Formula
  desc "C++ utilities"
  homepage "https://github.com/biojppm/c4core"
  url "https://github.com/biojppm/c4core/releases/download/v0.5.0/c4core-0.5.0-src.tgz"
  sha256 "ef017202e7c00ebf6cd4d20c767706e3a32d1f41daf58955888e27230e9940ba"
  license all_of: ["MIT", "BSL-1.0"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "47e5f4b48e45c4f2e6d31d6687d73c98e18743ef27ba5487117a71b73438b406"
    sha256 cellar: :any, arm64_sequoia: "560f72fc757eece10081db572b0c3ae0189ac33d36c5b3b2eda1d6b103407b54"
    sha256 cellar: :any, arm64_sonoma:  "52d5dbed115ea83c554238c944c0fc3b81c627e477b852376588bc5dc8a7eafb"
    sha256 cellar: :any, sonoma:        "8ce0b5fe575426a294d888509fcec0fa343aecf208008ca76c7cb16c9b429408"
    sha256 cellar: :any, arm64_linux:   "5d2b47d614bf594dc5ca6a5c00fcd36ef1d521287d3d2768c09c3a9342225c87"
    sha256 cellar: :any, x86_64_linux:  "038e548d96ae055ae98833872ca05d31522cac1fea601f155b62e3882012db9e"
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
