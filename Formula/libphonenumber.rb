class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/googlei18n/libphonenumber"
  url "https://github.com/googlei18n/libphonenumber/archive/v8.3.2.tar.gz"
  sha256 "f261f62452a19017d39fb5eb5dbea9cdd177ffa4c73f9ca21e0df36834c62276"

  bottle do
    cellar :any
    sha256 "e4dfea65d8115d8a9e82d5ad46ff26bb001895d8df9fcc477bc28a1f158014b3" => :sierra
    sha256 "23daf723cfc88f50e1b4d6af87b4fb40fe91ac242e9c0000dd7bb2d373805049" => :el_capitan
    sha256 "75b9e3f07c4c163883b800fe880f76e151a48601d1db653b68f4f485408a8b1e" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on :java => "1.7+"
  depends_on "icu4c"
  depends_on "protobuf"
  depends_on "boost"
  depends_on "re2"

  resource "gtest" do
    url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/googletest/gtest-1.7.0.zip"
    sha256 "247ca18dd83f53deb1328be17e4b1be31514cedfc1e3424f672bf11fd7e0d60d"
  end

  def install
    (buildpath/"gtest").install resource("gtest")

    cd "gtest" do
      system "cmake", ".", *std_cmake_args
      system "make"
    end

    args = std_cmake_args + %W[
      -DGTEST_INCLUDE_DIR:PATH=#{buildpath}/gtest/include
      -DGTEST_LIB:PATH=#{buildpath}/gtest/libgtest.a
      -DGTEST_SOURCE_DIR:PATH=#{buildpath}/gtest/src
    ]

    system "cmake", "cpp", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <phonenumbers/phonenumberutil.h>
      #include <phonenumbers/phonenumber.pb.h>
      #include <iostream>
      #include <string>

      using namespace i18n::phonenumbers;

      int main() {
        PhoneNumberUtil *phone_util_ = PhoneNumberUtil::GetInstance();
        PhoneNumber test_number;
        string formatted_number;
        test_number.set_country_code(1);
        test_number.set_national_number(6502530000ULL);
        phone_util_->Format(test_number, PhoneNumberUtil::E164, &formatted_number);
        if (formatted_number == "+16502530000") {
          return 0;
        } else {
          return 1;
        }
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lphonenumber", "-o", "test"
    system "./test"
  end
end
