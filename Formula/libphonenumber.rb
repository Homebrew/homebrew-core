class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.31.tar.gz"
  sha256 "2e4cdb69843598464dce4820b312b4bb2ba3faf1c2e7aabe87b6693b2d4581b9"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "b73d8793448bf17f46e3a8a5b5bbecb9ace9490a863afbb53d3be422fd1aa9ab"
    sha256 cellar: :any,                 big_sur:       "48d0fe6f99c03f19706b81fbf684a5228ba8c3dad00b8d7ceb43e9fa7d5bcb61"
    sha256 cellar: :any,                 catalina:      "8790b14e280251d65492cd659f0ab09587ba1a1bb5497b6ab311e8453e5b2ad1"
    sha256 cellar: :any,                 mojave:        "ff5214d356b5750557a1f54d740321b5900c1bd87c0a3c18c3aa94a43ac0daa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f690cd0b372df2d108b154711e120496ce0750ac64e3d540ad20afb99e9e3e68"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "boost"
  depends_on "icu4c"
  depends_on "protobuf"
  depends_on "re2"

  def install
    ENV.cxx11
    system "cmake", "cpp", "-DGTEST_INCLUDE_DIR=#{Formula["googletest"].include}",
                           *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
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
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lphonenumber", "-o", "test"
    system "./test"
  end
end
