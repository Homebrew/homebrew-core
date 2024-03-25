class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v8.13.33.tar.gz"
  sha256 "656c080c0fd713b9bed61efda4b006846d40914b5412d6d7082a5397653e2fef"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "86869d73230f60639dfef1a4dc32ae47b09821bfe94d62cd842bd9f81197a8bd"
    sha256 cellar: :any,                 arm64_ventura:  "64e5e8bc9d15c9d6c9c2335543fc7df63f90fb9ecbd78940d8b549b3c35834c8"
    sha256 cellar: :any,                 arm64_monterey: "cc921ee961ca09db4eaa3412efeeeeb5a591b5c52ce4f80b2972a95fb8665120"
    sha256 cellar: :any,                 sonoma:         "d42ac1f434fede1dff589ed6cc565bb0ddd82d6b78d50412e88c32187a881465"
    sha256 cellar: :any,                 ventura:        "679983a9280f575adac2b66dabd7d412c86ae587d0d7f8bf65bce60bc78de811"
    sha256 cellar: :any,                 monterey:       "e5465a10798566a6db4ec602f07f029e8b96e07557531e071fad56cdfe9b61ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abd1824c03b5355dd2a3df3f245bbf7d61e38a360e01675b6fee0e0e87d79b73"
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
