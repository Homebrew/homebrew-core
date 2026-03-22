class HowardHinnantDate < Formula
  desc "C++ library for date and time operations based on <chrono>"
  homepage "https://github.com/HowardHinnant/date"
  url "https://github.com/HowardHinnant/date/archive/refs/tags/v3.0.4.tar.gz"
  sha256 "56e05531ee8994124eeb498d0e6a5e1c3b9d4fccbecdf555fe266631368fb55f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a6e3a0832d810528b3b0199ad47d10e1f026e0de3559a66312f3343da396a26e"
    sha256 cellar: :any,                 arm64_sequoia: "fa799d065c7607f2e6997dfcb9d381de6b988b491a11b2d8ec78cafbc48e6914"
    sha256 cellar: :any,                 arm64_sonoma:  "28b75e11d6e62d271cc828016689daf84f05dcc804abd5652e3de61c8a3ea4f4"
    sha256 cellar: :any,                 arm64_ventura: "4c9f4bd167d09b5c525e7fca5ffff153a4d61496c22f75fa0455bb6d2e79d929"
    sha256 cellar: :any,                 sonoma:        "87f1f12799f3987a0f5fbb8d192124596a5e367a403160d39e24cfc2775be2e3"
    sha256 cellar: :any,                 ventura:       "17e09adc1f5575bd819e4cc6c42e4113b149da4531fd826923cca2b1626fe2e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfdca01d3aa4278c4c1a99428cdc1de38a7c3f15a172a2e157facc5e9b4b9930"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8fa6eff9c09d59e6e764b436f1354ef2821be373f44adb97ac158d6562b69fa"
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
