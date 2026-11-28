class HowardHinnantDate < Formula
  desc "C++ library for date and time operations based on <chrono>"
  homepage "https://github.com/HowardHinnant/date"
  url "https://github.com/HowardHinnant/date/archive/refs/tags/v3.0.6.tar.gz"
  sha256 "19f393877190e346ecbded5df4bbbb9bbfcc5aa57008becafeaacf5ea32d210b"
  license "MIT"
  compatibility_version 1

  bottle do
    manifest_sha256 "2e79d1827284e0fa94de0b3fc5f3c0c1e30c928b7a58bd51a4364305224615a7"
    sha256 cellar: :any, arm64_golden_gate: "bdae63021b7b7c4dc335634aa60699ad9a6ffa80f139871ff08f06f64552d821"
    sha256 cellar: :any, arm64_tahoe:       "08be2d50fb26f3159ee8587a34cf24922dd1c94b33af79e4572533f42aa46a7d"
    sha256 cellar: :any, arm64_sequoia:     "bb789248acfe891c7ddb2b7dbf170254eb075c75d50e8c5e36d15045ec340411"
    sha256 cellar: :any, arm64_linux:       "6336b97659fadb732376e0033665efedef328b63cc5a0f925cd223ced333fa5c"
    sha256 cellar: :any, x86_64_linux:      "06392547813f504b69e59a8efe812fe8eca45b9bb67645940be35afe9bb4a19e"
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
