class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/googlei18n/libphonenumber"
  url "https://github.com/googlei18n/libphonenumber/archive/libphonenumber-7.6.1.tar.gz"
  sha256 "2ed406c2b535f496a1ce9ced2ceefaa40c8473ad6dc53bb7e5fe0279f107333f"
  revision 1

  bottle do
    cellar :any
    sha256 "4d1e8212d1916192f554e8a8820b5e110b153c065c69d83be6135f03cc348b55" => :el_capitan
    sha256 "f4d59336e25b56e5000683d05248f7cfba8c8c156f54856ad7160ffc5402351a" => :yosemite
    sha256 "1cb4ae7163baf408887c89316f0b3ef72210c39022b9794cede0ef4c7e7c52d0" => :mavericks
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
