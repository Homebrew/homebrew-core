class HowardHinnantDate < Formula
  desc "C++ library for date and time operations based on <chrono>"
  homepage "https://github.com/HowardHinnant/date"
  url "https://github.com/HowardHinnant/date/archive/v3.0.0.tar.gz"
  sha256 "87bba2eaf0ebc7ec539e5e62fc317cb80671a337c1fb1b84cb9e4d42c6dbebe3"
  license "MIT"

  bottle do
    cellar :any
    sha256 "336157e546ea77db5ec3c0360b4e873e8c6ec265aa6dedb2fe19d45a6df207fb" => :catalina
    sha256 "20a35158d9c478a553baae673544620546db6f31825f9e052a0bbf07086e773e" => :mojave
    sha256 "f23b72ea88d5c0bc12f2e93dff65ba6a9867d88831294fc5c770f2d0a39762fa" => :high_sierra
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
