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
    sha256 cellar: :any,                 arm64_sonoma:   "20a26e3f760f53fa3393918c4f0e700564cbb538c39c1db4df86fcd52b20dc0a"
    sha256 cellar: :any,                 arm64_ventura:  "54589793e67d70e42999ae3a87bce43906a23a4dd34ad46e47fe402154c3b349"
    sha256 cellar: :any,                 arm64_monterey: "543cfd4192633433551b6e4e74eed38eab35a79dcab739e90986516ac8834d52"
    sha256 cellar: :any,                 sonoma:         "f30f877e941f61ebaf2b2599648ebf053410e75df06fec9a3759a06a66ff71cc"
    sha256 cellar: :any,                 ventura:        "c0551823e4ffab3999beb9f6d8ed65b981a675bca8a27716924242fad939b417"
    sha256 cellar: :any,                 monterey:       "7f92f8d2c700d5df72b3ed9b59ecc531ae1d6a38827f253524edcaf6223e5e73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a1bf7a0a1be9a259612cc4a6d0fda7bb9da9148b9bad3db0f5b67ddf30430b9"
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
