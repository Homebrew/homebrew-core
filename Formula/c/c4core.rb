class C4core < Formula
  desc "C++ utilities"
  homepage "https://github.com/biojppm/c4core"
  url "https://github.com/biojppm/c4core/releases/download/v0.2.10/c4core-0.2.10-src.tgz"
  sha256 "646ea4f33daeae123b8cb1006a977b8f23b9e07c177dcdb4c6600fdfa0489cfe"
  license all_of: ["MIT", "BSL-1.0"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b1e3be7faf35ab9214548cb3cea44bfff4ca6df4974e4350861b08d26ed79a1b"
    sha256 cellar: :any,                 arm64_sequoia: "af79a8173638651f2b1d8bd8a40f54a0512bf94abc155c3f2ded64b933738048"
    sha256 cellar: :any,                 arm64_sonoma:  "1258517cccb53eb7f0ff1e0501cc5bc3dc5e870ec4e2228d28ea4e7507b7725c"
    sha256 cellar: :any,                 sonoma:        "f1530f0d47cda8497e0ac0d35b2872e9d4a5390af644a0e229dff863ff53692b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3f26b2896e5cb7a47124f788a5684ece66a8463874d666083fa42c7d9212cfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26610b79561c42541ba69e1801932965c6f49ab5110c847959812f26bc084d4b"
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
