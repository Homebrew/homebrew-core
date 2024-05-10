class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v8.13.36.tar.gz"
  sha256 "370854023d0495b137a403a024c4c610a8c67aed05ef5e0b62a37454060be3d8"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "46fa2ce00f3f76807b838f9077c3d07210730a560b66631309f33d59faf9c44e"
    sha256 cellar: :any,                 arm64_ventura:  "57f72ea33cd950b9c4ffa4d5346b25ae4eaa219672a543c6bf4a7ccdfaeedc28"
    sha256 cellar: :any,                 arm64_monterey: "94a56299983013874e60403efbb2e335f504950ebce46e72dd172daf5b3a37b2"
    sha256 cellar: :any,                 sonoma:         "042b656f02977359dc609d4cee89142ce7b43d2296e988ad8fdfe854e2f0e6eb"
    sha256 cellar: :any,                 ventura:        "c49aba202ed9583d494f4f8f793daa1b3e5c77a9c0bde7cfed6552876b3a1d4e"
    sha256 cellar: :any,                 monterey:       "90ec070bb8ee0c407da85c95c2e67b1df2b9f466a8992389abcbd096d307b1c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98f57aa2ff18abcf8d94c3c06d75a6b2479ba7ba14edfd0ab4c835c9b8018b5c"
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
