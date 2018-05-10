class Cppdate < Formula
  desc "C++11/14/17 library for Date and Time operations based on <chrono> header"
  homepage "https://github.com/HowardHinnant/date"
  url "https://github.com/HowardHinnant/date/archive/v2.4.1.tar.gz"
  sha256 "98907d243397483bd7ad889bf6c66746db0d7d2a39cc9aacc041834c40b65b98"

  depends_on "cmake" => :build
  needs :cxx11

  def install
    custom_cmake_args = ["-DENABLE_DATE_TESTING=OFF",
                         "-DUSE_SYSTEM_TZ_DB=ON",
                         "-DBUILD_SHARED_LIBS=ON"]

    system "cmake", ".", *std_cmake_args, *custom_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "date/tz.h"
      #include <iostream>

      using namespace std;
      using namespace std::chrono;
      using namespace date;
      
      int main() {
        auto t = make_zoned(current_zone(), system_clock::now());
        cout << t << endl;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++1y", "-ltz", "-o", "test"
    system "./test"
  end
end
