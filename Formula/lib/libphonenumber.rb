class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.13.21.tar.gz"
  sha256 "bca757a8e04849c8158bbbc243c500699daa7601d1fd23a1277fc2643188b44b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5118b6bad63f63b6d7622764178be5f2a26e407dc74b431a562ce9c04ed445c1"
    sha256 cellar: :any,                 arm64_ventura:  "21a3a475b9b870a53540ceb6dba7f20740b5a1c735c2d0afe7dffeda616a1b61"
    sha256 cellar: :any,                 arm64_monterey: "7ce9fe50a39ae9db051868b9556f2bbb6c3091661fcca726778a8670a079e260"
    sha256 cellar: :any,                 arm64_big_sur:  "fedf724d2955f069ee9a513babe657b1300d55f66fb5fa64dd0d44718d60d6f7"
    sha256 cellar: :any,                 sonoma:         "d93656b2580ee70b076313691ef8df1cf574f5d7e8bebe0b7209534206116557"
    sha256 cellar: :any,                 ventura:        "77b45e40d790accc6663fa77496bed64163dfab386a68a2aab74d8ee2c54ddb4"
    sha256 cellar: :any,                 monterey:       "61c27850633c036763947c586bf2c247d60ee2371508e4caf34dc2025c959d08"
    sha256 cellar: :any,                 big_sur:        "99b5759b5f8645392176418c42b2ee0e29c496ae4054d2fa762156b024bc80ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f55aebcfdaa44ea71bdf5021547920a2e8d759911d618104495deb293e131daa"
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
