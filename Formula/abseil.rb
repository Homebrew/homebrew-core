class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://github.com/abseil/abseil-cpp/archive/20210324.2.tar.gz"
  sha256 "59b862f50e710277f8ede96f083a5bb8d7c9595376146838b9580be90374ee1f"
  license "Apache-2.0"
  head "https://github.com/abseil/abseil-cpp.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "5f0df7a96ad8c9c18eaaceba9766f44cf3840998ff61e2d7ee500c8b977000dc"
    sha256 cellar: :any, big_sur:       "347ae638cc4d1879185f873fb5277a25c57f1278f7a580110a64812c763a54d1"
    sha256 cellar: :any, catalina:      "340c8877e8b1e194a119f7ef06bbddbdd1f1fa057131ef1fd62f1950f06ed33e"
    sha256 cellar: :any, mojave:        "9d8dfb1629092f243180a93696aea57614c20387f8bf54ae0846e8a82c79a89c"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..",
                      *std_cmake_args,
                      "-DCMAKE_INSTALL_RPATH=#{rpath}",
                      "-DCMAKE_CXX_STANDARD=17",
                      "-DBUILD_SHARED_LIBS=ON"
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <iostream>
      #include <string>
      #include <vector>
      #include "absl/strings/str_join.h"

      int main() {
        std::vector<std::string> v = {"foo","bar","baz"};
        std::string s = absl::StrJoin(v, "-");

        std::cout << "Joined string: " << s << "\\n";
      }
    EOS
    system ENV.cxx, "-std=c++17", "-I#{include}", "-L#{lib}", "-labsl_strings",
                    "test.cc", "-o", "test"
    assert_equal "Joined string: foo-bar-baz\n", shell_output("#{testpath}/test")
  end
end
