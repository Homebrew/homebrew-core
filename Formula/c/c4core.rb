class C4core < Formula
  desc "C++ utilities"
  homepage "https://github.com/biojppm/c4core"
  url "https://github.com/biojppm/c4core/releases/download/v0.2.1/c4core-0.2.1-src.tgz"
  sha256 "6447896444c59002af58c8543d0bc64184b9a5c5992c8fc09d6d71935d039f89"
  license all_of: ["MIT", "BSL-1.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d8985ef79a45d0c1b331e3adfd6aa3773770f58106a0a9271b7ae32e988ba572"
    sha256 cellar: :any,                 arm64_ventura:  "7e06d49a3eca20a04813125846c6a83cf5568513690a003c7e5baab21156f951"
    sha256 cellar: :any,                 arm64_monterey: "17cc39af7e90c227538bfe3fae4ee2e38fa73b63ff4ed3eef479f57d87bc7326"
    sha256 cellar: :any,                 sonoma:         "a4ef40c6de54f65ec25d6a871e962cbc1b5b88c7a3acde0f01019b99c985a922"
    sha256 cellar: :any,                 ventura:        "2ca5b98b27d0e053138b3f4351a104a4f2ed8cfa827635dca1ec3d52a9b1876f"
    sha256 cellar: :any,                 monterey:       "e77b9a38beed8da8a210ff9392049dc82b53ddc06d94faaa1609aeba81c21974"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "554f096bd5eaac039c72874ef16e2a4945de8b57ac8bdd98b1677e2434d79dac"
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
