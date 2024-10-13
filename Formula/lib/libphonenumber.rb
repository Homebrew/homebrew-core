class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v8.13.47.tar.gz"
  sha256 "b56ef9dbdfd91968242d63e38457cf58f1c03ddff5a9cb8862dd0138419f6cd2"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9368e6ebb90d92ad63a1a8d42fb7193e832e0e941236a7b7b361904d257d49d5"
    sha256 cellar: :any,                 arm64_sonoma:  "b55cd2955482f867d11222e395e48221c9c8d93ec7a58e9f76f665057726d6e9"
    sha256 cellar: :any,                 arm64_ventura: "56ff353ae83e9d176e476441f0a269edc6c0c5c75f0d9c9fe6c2ccfe348e7da3"
    sha256 cellar: :any,                 sonoma:        "61a70ae92b382b6821b673db9bed6b99af2f003c82e8f707f226e0c7956921c5"
    sha256 cellar: :any,                 ventura:       "69fcafbd8223f8d4ec935e711b2feb358fa75118968698330ecf53d8084e4046"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28094999cf5a057ab93f4379c271d7973481a31cecc7e1f6d6005085c8749e7d"
  end

  depends_on "cmake" => :build
  depends_on "openjdk" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "icu4c@75"
  depends_on "protobuf"

  fails_with gcc: "5" # For abseil and C++17

  def install
    ENV.append_to_cflags "-Wno-sign-compare" # Avoid build failure on Linux.
    system "cmake", "-S", "cpp", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=17", # keep in sync with C++ standard in abseil.rb
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
        std::string formatted_number;
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
    system ENV.cxx, "-std=c++17", "test.cpp",
                                "-I#{Formula["protobuf"].opt_include}",
                                "-L#{lib}", "-lphonenumber", "-o", "test"
    system "./test"
  end
end
