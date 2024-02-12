class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v8.13.30.tar.gz"
  sha256 "126d2680c282107fcb54286fbae5709df84d7ec2e93ce94f3ab4ae373dff6c3e"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "227231456ed2ce44bb4219cbb3bc825204f407bd74f7b77d71bf39480143d223"
    sha256 cellar: :any,                 arm64_ventura:  "705f91b2af236e3615cb7fcaccde3d5ee48f98592a22e08cb0bdc998423d4972"
    sha256 cellar: :any,                 arm64_monterey: "0977ac81a0a081d47268aa6b8e98b59ddf45ce491250c45adff82e8046cdf34c"
    sha256 cellar: :any,                 sonoma:         "5dd7c6d9c86fe3af2e6d8d52ff1e9cf897383d61b4b66f3283932bf6243b5794"
    sha256 cellar: :any,                 ventura:        "f3eeaaa0e0a51781e5d1b635ffc0dd6a02fecdc7507059355dbc54e6bc7d2e76"
    sha256 cellar: :any,                 monterey:       "16e973284544e989f6198c0a0469b531b86619bcb15f5221696d2fa5029f5392"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed34bcba9b0a2d1f3f083607a163053012130d8abd3f6fa8b6e0ac2db62e8728"
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
