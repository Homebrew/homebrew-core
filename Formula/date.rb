class Date < Formula
  desc "C++11/14/17 library for Date and Time operations based on <chrono> header"
  homepage "https://github.com/HowardHinnant/date"
  url "https://github.com/HowardHinnant/date/archive/v2.4.1.tar.gz"
  sha256 "98907d243397483bd7ad889bf6c66746db0d7d2a39cc9aacc041834c40b65b98"
  head "https://github.com/HowardHinnant/date.git"

  option "with-system-tz-db", "Use the operating system's timezone database"
  option "without-shared", "Build a static version of library"

  depends_on "cmake" => :build
  needs :cxx11

  def install
    custom_cmake_args = ["-DENABLE_DATE_TESTING=OFF"]

    if build.with? "system-tz-db"
      custom_cmake_args << "-DUSE_SYSTEM_TZ_DB=ON"
    else
      custom_cmake_args << "-DUSE_SYSTEM_TZ_BD=OFF"
    end

    if build.without? "shared"
      arcustom_cmake_argsgs << "-DBUILD_SHARED_LIBS=OFF"
    else
      custom_cmake_args << "-DBUILD_SHARED_LIBS=ON"
    end

    system "cmake", ".", *std_cmake_args, *custom_cmake_args
    system "make", "-j#{ENV.make_jobs}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "date/date.h"
      #include <type_traits>
      static_assert(std::is_same<decltype(date::last), const date::last_spec>{}, "");

      int main() {

      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++1y", "-o", "test"
    system "./test"
  end
end
