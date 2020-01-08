class HowardHinnantDate < Formula
  desc "C++ library for date and time operations based on <chrono>"
  homepage "https://github.com/HowardHinnant/date"
  url "https://github.com/HowardHinnant/date/archive/v2.4.1.tar.gz"
  sha256 "98907d243397483bd7ad889bf6c66746db0d7d2a39cc9aacc041834c40b65b98"

  bottle do
    cellar :any
    rebuild 1
    sha256 "7afeb7e1b64e9e78d766be80a2e95c51b404092eeb1e5deb4d84956eeb02aff3" => :catalina
    sha256 "d1601c1a3c38241472d597a126ed120124995919e42d5a9cc10357c699d1b5e7" => :mojave
    sha256 "f7600a317e2569e37ac78be36abaff96f8f572cd7650d9c202a5a758f59f46f8" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args,
                         "-DENABLE_DATE_TESTING=OFF",
                         "-DUSE_SYSTEM_TZ_DB=ON",
                         "-DBUILD_SHARED_LIBS=ON"
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
    system ENV.cxx, "test.cpp", "-std=c++1y", "-L#{lib}", "-ltz", "-o", "test"
    system "./test"
  end
end
