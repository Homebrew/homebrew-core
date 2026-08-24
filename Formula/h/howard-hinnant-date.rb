class HowardHinnantDate < Formula
  desc "C++ library for date and time operations based on <chrono>"
  homepage "https://github.com/HowardHinnant/date"
  url "https://github.com/HowardHinnant/date/archive/refs/tags/v3.0.5.tar.gz"
  sha256 "ef786edc203daec76475825640b3af247bd08e31fc52217e5ce8f76107b4bb05"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "08d425d276d462c1b67bd2ae8e4fc27a6719bfcf614c83a395950a4c748bf520"
    sha256 cellar: :any, arm64_sequoia: "edfd31d06de8c45bf8494b2be67466ad7119641ffa29faacb37e91c1ba38f0a4"
    sha256 cellar: :any, arm64_sonoma:  "1d81e0b579ffcf1c93673c1cfe9d882c38b99aaa343342b9b1688309d9c2c876"
    sha256 cellar: :any, sonoma:        "a69eb41463b79ce173d1f955caf13856abb06dbc1d6639936fcda604e828df73"
    sha256 cellar: :any, arm64_linux:   "eda5d808784224ffc2841a9c51829514eb22d0408b227f3c2eb7cbd711e08de6"
    sha256 cellar: :any, x86_64_linux:  "9deaee6eb543f5ada3286b05853300472fd5735cbe61f0f4cec122105e546c5c"
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
