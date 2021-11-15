class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.37.tar.gz"
  sha256 "e95c210b446ed7503b5bb46c6010e33dbd0e33348be89365d6fd630b9b8a0b68"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "51ff4668239561d714480f42775101875d7bd1b8d3f7df2964a9d8706807d116"
    sha256 cellar: :any,                 arm64_big_sur:  "7334cad9e1958f56f85a43d31a7c4c06ada205bee2c102c8209cce089e34f623"
    sha256 cellar: :any,                 monterey:       "025acc7cb28e5bd8f24db26009f8d7bf1f71e3ebcf72237bf9bdfa499db4ec78"
    sha256 cellar: :any,                 big_sur:        "05c45e58c7d3f8159ff1f6db406f6f058ae298cc7b0975faf2f030c5f8a4a23b"
    sha256 cellar: :any,                 catalina:       "e0684c6f414123933626eea843d1e9261472895e358aac94dfd3c6a1ef17b491"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18a83b0c5674864509bfce71269ed55809714e76a23119bb79070fb8feb4b0e1"
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
