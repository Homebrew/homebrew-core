class C4core < Formula
  desc "C++ utilities"
  homepage "https://github.com/biojppm/c4core"
  url "https://github.com/biojppm/c4core/releases/download/v0.2.7/c4core-0.2.7-src.tgz"
  sha256 "0856eb232833aa977675cee028c2f32fea631652b65991056d540a0909c2a075"
  license all_of: ["MIT", "BSL-1.0"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cf2facaac44932248601cf8650afa39a38cc71771584bc0155cff50aa06f3be2"
    sha256 cellar: :any,                 arm64_sequoia: "88b0fd5e35a5a87acb98c73269e37e15155cef0c910a14a51d7309b8c70be32f"
    sha256 cellar: :any,                 arm64_sonoma:  "6fff2dd5ef75cb972b968cc94a6c76a2220cf7c202900bf6b6e1047b72564c6c"
    sha256 cellar: :any,                 sonoma:        "bd22f2bf0b7c2ef8a77630ab4ab3f7cf433e12de52c7bef0cee542da66ed523f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8331d875c6235deb6ec8447ba76df7138befef5a7a171a71b247f61f5a1b4018"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84695f8ba51365e3d6c792d1f17b57c681869817a3c44f7b259765ccc0410b93"
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
