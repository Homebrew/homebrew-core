class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/googlei18n/libphonenumber"
  url "https://github.com/googlei18n/libphonenumber/archive/v8.2.0.tar.gz"
  sha256 "6448ccd94ad3acc829e208eb3499a0acf8a38513b75d20e7b4218a6e00fe9528"

  bottle do
    cellar :any
    sha256 "95e9f1bc5dde2f555e46860bb1ebaecd3c35a85f2ecdcb077234166e0aa83ca0" => :sierra
    sha256 "6709e00db5f6da3241e5941d27cba192f0fa2f370f565b5e45028e6bcd686067" => :el_capitan
    sha256 "c76857847365793983eb9e2f271754275dbb09a775464ee0e160a5b3a9f3e508" => :yosemite
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
