class HowardHinnantDate < Formula
  desc "C++ library for date and time operations based on <chrono>"
  homepage "https://github.com/HowardHinnant/date"
  url "https://github.com/HowardHinnant/date/archive/v3.0.1.tar.gz"
  sha256 "7a390f200f0ccd207e8cff6757e04817c1a0aec3e327b006b7eb451c57ee3538"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c883e4cb240a19756b28270cfde1fb71adf879e2aefb380f6c01ff0b4b6b8989"
    sha256 cellar: :any,                 arm64_monterey: "52811eb710a07d879d153a65bc6c771a8ff801f990a6bd2f968d1238c6000b03"
    sha256 cellar: :any,                 arm64_big_sur:  "deff47e2027f805ef5cd430d0700470cf8bada0cde442e8674ae6a832e3b9888"
    sha256 cellar: :any,                 ventura:        "372312fabb0cbb4e07ae4bc2f8cdf36ae6128a6bfea018f342f8b8fab211a9c8"
    sha256 cellar: :any,                 monterey:       "0098680dad7ff5cb5854d04ab0aff279641892d1c8c3079658bfe2762bb1b6f9"
    sha256 cellar: :any,                 big_sur:        "b8fc90e684f2d3b711fcb405c082f8ad637eac8f6c5816b746284c911950eb5a"
    sha256 cellar: :any,                 catalina:       "bebf754666baa69673a77fb5eeb3c0ebe9931b7aa2d3991a3f6fa235a439d11b"
    sha256 cellar: :any,                 mojave:         "d140b4b590c5ef8c25e80abaa8466dbcb6f10a95ca0dec551de7fb0e213171b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2361559d178154d8e6f69b1da915838ab17271a61d3ff808db1ed2ca8ce7091f"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args,
                         "-DENABLE_DATE_TESTING=OFF",
                         "-DUSE_SYSTEM_TZ_DB=ON",
                         "-DBUILD_SHARED_LIBS=ON",
                         "-DBUILD_TZ_LIB=ON"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "date/tz.h"
      #include <iostream>

      int main() {
        auto t = date::make_zoned(date::current_zone(), std::chrono::system_clock::now());
        std::cout << t << std::endl;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++1y", "-L#{lib}", "-ldate-tz", "-o", "test"
    system "./test"
  end
end
