class C4core < Formula
  desc "C++ utilities"
  homepage "https://github.com/biojppm/c4core"
  url "https://github.com/biojppm/c4core/releases/download/v0.2.6/c4core-0.2.6-src.tgz"
  sha256 "203a8dbd156b1b5062959627b7757f8953d03ab05a992ecc471fcefe7274194b"
  license all_of: ["MIT", "BSL-1.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5f2518dbe8f273c8320bcd8f2a632c747578c0f7638cb733aa884e0ae6827eca"
    sha256 cellar: :any,                 arm64_sonoma:  "a392aee67ab2432ce106b4631661ac9565407a74f380523d1cc2f3cd4539850d"
    sha256 cellar: :any,                 arm64_ventura: "4bc536148a179f28a9b4bd28f81821084d0fdce24f3aa5e39c75093d0dc7d8f1"
    sha256 cellar: :any,                 sonoma:        "7799e77cad48cbc3d89bb3ac6f7e908264df34254d496912b8d739ced5aa0386"
    sha256 cellar: :any,                 ventura:       "05cf45edbe989806426ac81fb605084e5b832f9dddf5f86953885c8708f6b69a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94e1da9372dd27bf1c64965212c79ae01acf0b3dbd344209f1042b2ab2fff357"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6260a2a167adcd57264516af9b9119b06b6d03b6dde21572e8d49e04c23e188"
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
