class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.54.tar.gz"
  sha256 "cf3d531a6b097cad508c475888bcf042ff15fabc6be05e3f817224ae8512ce63"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "18f4714f4d30a68f29f3b86fa117994b2619cb33543074a9f4a7c8aad4cb21f7"
    sha256 cellar: :any,                 arm64_big_sur:  "c34b2c5c576ec8b52c786dfd47f8432b40d292c1d63a5f5214683d8bd992a47b"
    sha256 cellar: :any,                 monterey:       "67df9e5453f451e363362dfbe806ec576325590800e3faead17fea32e022241f"
    sha256 cellar: :any,                 big_sur:        "df4aff1b264a472e3cdadf2e8c9b66db61e35cfd621ece6b6c90fdf1da361114"
    sha256 cellar: :any,                 catalina:       "56851d21d5d81fec19285cbe0fa741a07b142ecda38cfd633fca584a26952656"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9a1b322f631942231db79e94f37fba24d54cd7a6a32d2111d2999e2246b4b57"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "icu4c"
  depends_on "protobuf"
  depends_on "re2"

  on_linux do
    depends_on "gcc"
  end

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
