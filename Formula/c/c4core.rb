class C4core < Formula
  desc "C++ utilities"
  homepage "https://github.com/biojppm/c4core"
  url "https://github.com/biojppm/c4core/releases/download/v0.2.12/c4core-0.2.12-src.tgz"
  sha256 "7b59eafe79a31413b974065d12bab28eaea55a01255c7127e26832d98bccf7be"
  license all_of: ["MIT", "BSL-1.0"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c42087bbdf8afd2aec78d2ee2cf4c6fe435c83efa0156d16b658eaf97ee1f096"
    sha256 cellar: :any,                 arm64_sequoia: "2291c1cc7c314e7c489eeb19447ac8d880bb522316801299c578f57d5aa6ee8f"
    sha256 cellar: :any,                 arm64_sonoma:  "083dde3e0202406a814c751160c26ac8405c546c6500b7e262abecd7ea90286f"
    sha256 cellar: :any,                 sonoma:        "2f353aea87a810ffaa91c959c0fe60e27184463eb4db94a0bdd67b53a5d61baa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec8e71a11f619d06a18d2accea21af933b855fdc5627d3b640b326f4475dc7c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "982dbacb2332d43ff89154989ef5bdc894514fb512d9e9b38717593d74ab2097"
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
