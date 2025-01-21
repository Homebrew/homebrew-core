class C4core < Formula
  desc "C++ utilities"
  homepage "https://github.com/biojppm/c4core"
  url "https://github.com/biojppm/c4core/releases/download/v0.2.2/c4core-0.2.2-src.tgz"
  sha256 "beea43a5bdc64616d897cc0af728f408e35e2d75a8bb6014e6e25e90e0484578"
  license all_of: ["MIT", "BSL-1.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "fe615637e6e596329673a4f5b2145cef977a7d0439d9b1122c1189692930b85b"
    sha256 cellar: :any,                 arm64_sonoma:   "2ac1666e0948d9827c198274de5c15df4917c9e696f00ed9a88a8cf64a21a196"
    sha256 cellar: :any,                 arm64_ventura:  "e78cfd204659c87379cbcb49bb8a68ada74d51a0414b7e0de65c5c7670938762"
    sha256 cellar: :any,                 arm64_monterey: "5cc4fdc91e5003b26f7d6650c473a6dfb071087062e643464e8fabd3c781a6c7"
    sha256 cellar: :any,                 sonoma:         "914136585b2600518396a3aa440bc98b08bbf639b048e527d75a4ef04825621a"
    sha256 cellar: :any,                 ventura:        "58d6d08c5701e896c5b104ca59f7db2a1953645192e048a8750f47dc96e77125"
    sha256 cellar: :any,                 monterey:       "164ba92cc794ee80c0b711bf2c0adec416064dd8495e86409868a6659dbea65e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53cc4f146f457587ddd700b590accab3b80b213cc27da7ecdb1da036f4d9288b"
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
