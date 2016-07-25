class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/googlei18n/libphonenumber"
  url "https://github.com/googlei18n/libphonenumber/archive/libphonenumber-7.5.0.tar.gz"
  sha256 "2a6720d4664fba23356824e1a2f70c0c893ee3d8d90c13b130f9349f466b99c5"

  bottle do
    cellar :any
    sha256 "f52f686c8703b491313f1c57b8fbc365a6b6adfd83477bd7c43dd9c76a13584c" => :el_capitan
    sha256 "859fe865e7aebe43f2c0bce3f223da7d96adf5bda1070db9ae63f7551058dce4" => :yosemite
    sha256 "387c2a3020434899857730c4cd14a095a8ed3d238a843bcc2a344d73e5779a25" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on :java => "1.7+"
  depends_on "icu4c"
  depends_on "protobuf"
  depends_on "boost"
  depends_on "re2"

  resource "gtest" do
    url "https://googletest.googlecode.com/files/gtest-1.7.0.zip"
    sha256 "247ca18dd83f53deb1328be17e4b1be31514cedfc1e3424f672bf11fd7e0d60d"
  end

  def install
    (buildpath/"gtest").install resource("gtest")

    cd "gtest" do
      system "cmake", ".", *std_cmake_args
      system "make"
    end

    args = std_cmake_args
    args << "-DGTEST_INCLUDE_DIR:PATH=#{(buildpath/"gtest/include")}"
    args << "-DGTEST_LIB:PATH=#{buildpath/"gtest/libgtest.a"}"
    args << "-DGTEST_SOURCE_DIR:PATH=#{buildpath/"gtest/src"}"

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
