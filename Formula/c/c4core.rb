class C4core < Formula
  desc "C++ utilities"
  homepage "https://github.com/biojppm/c4core"
  url "https://github.com/biojppm/c4core/releases/download/v0.2.8/c4core-0.2.8-src.tgz"
  sha256 "cc7ced8917725c15d98bc6fee180125d424773192f403cf4092280bcc87f6a30"
  license all_of: ["MIT", "BSL-1.0"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1a554d823764d6c65e0d7ec045bb472cc5fac22fb9a42827fa9e0aefaddc9c74"
    sha256 cellar: :any,                 arm64_sequoia: "40b585c4a5f3e4aaa1543cef5ad30a46c63916678d208b0767833fe384f58e28"
    sha256 cellar: :any,                 arm64_sonoma:  "214368d11d69339d8dddcc9cf259924d45a004330c9a39aa5b3111f308346b2f"
    sha256 cellar: :any,                 sonoma:        "9339d0df1b1225eb31fecac86de3cb574907ee293b9a2c852183e9cc32cf6275"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e765b22cfa7ac54b78da4d2a8ed2e440838d2269c7e7d9cb08cbd608b20ed1c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06d0bba26b2899cbca6e5484be8c98390da6e4dd446fff62bb647cdeae9b6278"
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
