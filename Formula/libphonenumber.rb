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
    sha256 cellar: :any,                 arm64_big_sur: "864428d392389a1be48a803a9acf2ab5a0752a535136e03e6c2ea2da83fd0de7"
    sha256 cellar: :any,                 big_sur:       "17892dfe525f4e92a2d6bc2fbab54b844beb67a48ea5824244b03c5b8e0a32b9"
    sha256 cellar: :any,                 catalina:      "1a1e6f5a71dac4b0a42eac3e84d49d8a58647bfe3c4b78613b6125fd1c28740b"
    sha256 cellar: :any,                 mojave:        "df48aaeb52ab9fcd9146b855cd076c914b1f1da912ba98ada6d7321a22656871"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e245f78e0d163c005fb7f2d75f1d8f6e947ba2790e64bf487b083f456cbbdf96"
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
