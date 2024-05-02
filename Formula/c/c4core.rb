class C4core < Formula
  desc "C++ utilities"
  homepage "https://github.com/biojppm/c4core"
  url "https://github.com/biojppm/c4core/releases/download/v0.2.0/c4core-0.2.0-src.tgz"
  sha256 "7843e6fb41c200fff69fc71105dbbf56bb410bdbab6b330e02cbe18430fe23bd"
  license all_of: ["MIT", "BSL-1.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5630ec5eb69c1e5e40858c6be9d7f625f6d53025ecd8644d63f5e152d45a96e3"
    sha256 cellar: :any,                 arm64_ventura:  "ff3d70ff20e632cee40b2829d03a112efbac95c68d106bd0cad4581331e5e9bb"
    sha256 cellar: :any,                 arm64_monterey: "57a49dc94ce29ed0fd5dc2f63044aebf2d99e85f3ca80899821609e371e576cf"
    sha256 cellar: :any,                 sonoma:         "618eeb4e9bada16ddf0154b48c469b61c212467d2604df1e0d86f919873756c5"
    sha256 cellar: :any,                 ventura:        "d451b94846b06a0ef00dd0a6bf014a82d9955388a1f5ef06a34b33df31d8ed17"
    sha256 cellar: :any,                 monterey:       "9cb88d3e47485790fabafae38b19c05596530e36c94d3dbc85309f24997d5d01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dad901b85c0fc6a4f68393e21338e92de8e2828e0da5ac853deb77c19b94dd74"
  end

  depends_on "cmake" => [:build, :test]

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.5)
      project(c4core_test)

      find_package(c4core)

      add_executable(c4core_test test.cpp)
      target_link_libraries(c4core_test c4core::c4core)
    EOS

    (testpath/"test.cpp").write <<~EOS
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
    EOS

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    assert_equal <<~EOS, shell_output("./build/c4core_test")
      The number is: 42
      Formatted number: 42
    EOS
  end
end
