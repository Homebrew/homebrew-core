class HowardHinnantDate < Formula
  desc "C++ library for date and time operations based on <chrono>"
  homepage "https://github.com/HowardHinnant/date"
  url "https://github.com/HowardHinnant/date/archive/refs/tags/v3.0.3.tar.gz"
  sha256 "30de45a34a2605cca33a993a9ea54e8f140f23b1caf1acf3c2fd436c42c7d942"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f5caa8a7a4f7072d005a62f565705607e1d5ff21ef112d5a911bacb3c8a1695b"
    sha256 cellar: :any,                 arm64_sonoma:  "fb88892a2b820b2e43c6b47af05740b6a5bd44e20335ec9ca23a5e247c0782ac"
    sha256 cellar: :any,                 arm64_ventura: "5c383e2d85dfb776bb86e0aa19cd34ae62510d87b725c6fde8dc18b199a9462d"
    sha256 cellar: :any,                 sonoma:        "a15f73654fcc9dc73f6628b06b13184127271c6090a340b160ecec12170d9c4b"
    sha256 cellar: :any,                 ventura:       "af3320951ccf968555f534e710b4ff9fa5ddb4a2b28d9422aa37424d45b1d0c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cd260df2059437676d4ffd985f8be01745964447e00c227bb8f3ea78355f650"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DENABLE_DATE_TESTING=OFF
      -DUSE_SYSTEM_TZ_DB=ON
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_TZ_LIB=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "date/tz.h"
      #include <iostream>

      int main() {
        auto t = date::make_zoned(date::current_zone(), std::chrono::system_clock::now());
        std::cout << t << std::endl;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++1y", "-L#{lib}", "-ldate-tz", "-o", "test"
    system "./test"
  end
end
