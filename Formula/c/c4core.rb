class C4core < Formula
  desc "C++ utilities"
  homepage "https://github.com/biojppm/c4core"
  url "https://github.com/biojppm/c4core/releases/download/v0.2.11/c4core-0.2.11-src.tgz"
  sha256 "151e53a30e4c53085c64d503a80e0ed65c55dd16e5b3b5af76927a54d5d66b90"
  license all_of: ["MIT", "BSL-1.0"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a2c627cad8c31cd9b8d11365ecb60e3f80e3f1053336fb063dc8dd2f022c8d83"
    sha256 cellar: :any,                 arm64_sequoia: "51924939a118ff3ed2c3316c76a376f63c76ec9cebe15441291e1658d19c7e40"
    sha256 cellar: :any,                 arm64_sonoma:  "56b62f0230c10cc4e168525a5b088879e3b40b8809b3a1b32fea6b1916817004"
    sha256 cellar: :any,                 sonoma:        "5a96101b5011083d69265525a95ba1a46479bbe1d51139d76dbda66a0ba76485"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0b0f901b0c3e1f7465a7feb1596f37f3a642bad98ca18b1285905b8f1120062"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83dd616cc7b083c7a8df745ab613ebaf72a3c9bd75193350e546345b76d851ed"
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
