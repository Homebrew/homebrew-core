class C4core < Formula
  desc "C++ utilities"
  homepage "https://github.com/biojppm/c4core"
  url "https://github.com/biojppm/c4core/releases/download/v0.4.0/c4core-0.4.0-src.tgz"
  sha256 "6703768e6ae3f623296d3fb5cff0fc74c08bfe45dc800234e0e42ba508e230a0"
  license all_of: ["MIT", "BSL-1.0"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "41e69163f9dcd18f7a640137795f782f7f11291ef4fcef76b2e57e4c2ccc3aa8"
    sha256 cellar: :any, arm64_sequoia: "56173430d14809736a1a9ba35a76056a9b6f4b1ae231a00b09b1cdd59afa4859"
    sha256 cellar: :any, arm64_sonoma:  "d2e6a9d2e32ce9f44282998ecb26db03f8f69ea479d7a1a2cdbbc2ca7ccd6054"
    sha256 cellar: :any, sonoma:        "4be149fe4b30785f5b82dd20ff0b42b4b87fc6e40e55a6d5753b3da8b0e51776"
    sha256 cellar: :any, arm64_linux:   "992304dfc681f3db1bb16be36890f450f0fed33b0d84def04c426360185218bd"
    sha256 cellar: :any, x86_64_linux:  "b24078fdc7a03d696a28baac7a545878d1b1f6a384ef6540ed8e527d4503ae1b"
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
