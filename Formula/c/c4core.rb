class C4core < Formula
  desc "C++ utilities"
  homepage "https://github.com/biojppm/c4core"
  url "https://github.com/biojppm/c4core/releases/download/v0.1.11/c4core-0.1.11-src.tgz"
  sha256 "67f4443f3742424f42453594e26e656f616dddfcf225a1d810e00473a741408c"
  license all_of: ["MIT", "BSL-1.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d2e73d851a2777b9df10eb937e1a4bbbf89aaee76e9320c5192339181e4aadf1"
    sha256 cellar: :any,                 arm64_ventura:  "1460fb66ee37eb0c57f61d40ea81f6a35509e171c2e3746abca337ee7f66f24a"
    sha256 cellar: :any,                 arm64_monterey: "fbb9103d688898c9d8f12e9558d331806f89840ece7a63e13861734333875bb1"
    sha256 cellar: :any,                 sonoma:         "a4312fdef6b2cb21b9d08a053401b0e74c56621437ea9e952f7c56e2accf126b"
    sha256 cellar: :any,                 ventura:        "08997fa1bda6673f3d47812d1f3aa74813176e3e332d68e426f4e38aa9064d47"
    sha256 cellar: :any,                 monterey:       "2053081e026e5e92f7431f0b22f8052eae0915722a72791203201a0be7574625"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa534b33171bcf2aeaf41ffe6cef097bb6fd972c3b9df4ca80ed6e101ef9769e"
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
