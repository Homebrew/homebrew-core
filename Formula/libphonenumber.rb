class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.55.tar.gz"
  sha256 "4bc493c51cdc7b833b5b24e53fea5f9799f6ed728608700779ca10a923f874d9"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b03936be7e5a0f75855fed8d1c62815c664ae7b41427be0d9bf62a89bdb7084f"
    sha256 cellar: :any,                 arm64_big_sur:  "f49456b3042c81e1cd365eb763eb0ccb997f8ffe0980bc75e81cd449fd39b73d"
    sha256 cellar: :any,                 monterey:       "c51ef7244c2e00743c9ad2b8314fdd2b20697d87ee3e2fe4729eaa77bb07b6df"
    sha256 cellar: :any,                 big_sur:        "242aaa282ed5ae3fc2dff339fbb4196a5d640d7c8b21ca3f43e211ba039e592d"
    sha256 cellar: :any,                 catalina:       "b15c17306303b5d8229e098a1889d5da008caef5a23387da8d9bebf7974e90b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8852155647bad3b16555f002fca1ce562f34416b7d4fbd6d51abae59cdd5d048"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "icu4c"
  depends_on "protobuf"
  depends_on "re2"

  fails_with gcc: "5" # For abseil and C++17

  def install
    system "cmake", "-S", "cpp", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=17", # keep in sync with C++ standard in abseil.rb
                    "-DGTEST_INCLUDE_DIR=#{Formula["googletest"].opt_include}",
                     *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lphonenumber", "-o", "test"
    system "./test"
  end
end
