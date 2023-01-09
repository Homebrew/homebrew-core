class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.13.4.tar.gz"
  sha256 "7c9d1b7bc3320e1a234bdd9435486bc01fca181d74455e2866af19543289ae6c"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bbadfbad12ade14b5962b46719e713ccdfe312bb85195fe3d895c74d1a4c30bd"
    sha256 cellar: :any,                 arm64_monterey: "2f8082fa1713d97ac53c28a12400bfd2366789a065a5e5fcaae24d3d4876b8e1"
    sha256 cellar: :any,                 arm64_big_sur:  "006c2df26205097c86fa76f20d45b2fe011cb32c0721324c9f69b44ea3703f00"
    sha256 cellar: :any,                 ventura:        "b964e50e2458519e16ba56e418d2d297f5128c75021b48b23a6d429a3b557376"
    sha256 cellar: :any,                 monterey:       "3d648bfbeae5325562fa4fb78c87f54a5cab11482fc8e5086272ded03bd90ee2"
    sha256 cellar: :any,                 big_sur:        "b179c88a7ac931aebbc67eddc872a3bbc0318d26adf779e47860ecb4ca2e6992"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01f292388cad008de68c734037ec6386fe4a70f90c121cd458469dacf8ca7729"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "openjdk" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "icu4c"
  depends_on "protobuf"
  depends_on "re2"

  fails_with gcc: "5" # For abseil and C++17

  def install
    ENV.append_to_cflags "-Wno-sign-compare" # Avoid build failure on Linux.
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
