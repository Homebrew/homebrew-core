class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.13.4.tar.gz"
  sha256 "7c9d1b7bc3320e1a234bdd9435486bc01fca181d74455e2866af19543289ae6c"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5ffd78d4aefdcadc833c6170955796775f3dc120a90f124f272ee5c3ab4ebf5c"
    sha256 cellar: :any,                 arm64_monterey: "468f138bb6ad2d0070dd6d5982d40721a64cf29da92311c4a55bd614d663569d"
    sha256 cellar: :any,                 arm64_big_sur:  "1e9403ed45672630c25cc887d87a76e7717ffa91fff344e6637a9ad365a1cbe4"
    sha256 cellar: :any,                 ventura:        "934e525fb2a7fc0511f324a0965457bc3a9982e3df11188bce4413279b59ec01"
    sha256 cellar: :any,                 monterey:       "9aedd0611834560383df4b04995c03983c1df53b6de077e03a722888813e426b"
    sha256 cellar: :any,                 big_sur:        "867427b81a98d1a9dd4bcb8b62890871fe7edff9eb31ce92baa5c1142543de19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "900b52fc09f6de9f6b7f37abce6a215dd038abf992f6e619d2daeaf618f8bced"
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
