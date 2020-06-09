class HowardHinnantDate < Formula
  desc "C++ library for date and time operations based on <chrono>"
  homepage "https://github.com/HowardHinnant/date"
  url "https://github.com/HowardHinnant/date/archive/v3.0.0.tar.gz"
  sha256 "87bba2eaf0ebc7ec539e5e62fc317cb80671a337c1fb1b84cb9e4d42c6dbebe3"

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
