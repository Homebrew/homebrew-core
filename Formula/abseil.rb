class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://github.com/abseil/abseil-cpp/archive/20210324.2.tar.gz"
  sha256 "59b862f50e710277f8ede96f083a5bb8d7c9595376146838b9580be90374ee1f"
  license "Apache-2.0"
  revision 1
  head "https://github.com/abseil/abseil-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4e91703b7dacaf6700dde159935d61884633f2d75c0b18b083af9744ab92620d"
    sha256 cellar: :any,                 arm64_big_sur:  "9d952d8755c1a1f6c7841cf34b4490dc472f76938ebee1dce2a65429273be564"
    sha256 cellar: :any,                 monterey:       "c6c76dc1c68ba3e959e8e785ad60d2b50bde8f1303a2afa29af04a8cbb8346df"
    sha256 cellar: :any,                 big_sur:        "d4373a873275884f01c18161826ae776d0b1d117eb3cf037763b906ccd3a60a6"
    sha256 cellar: :any,                 catalina:       "a087569c2b0fe24bc55d24f4561542955ccb2b95d2cd27ef23f3c86e79c5893d"
    sha256 cellar: :any,                 mojave:         "50fc095da0f1105b9d9edc73251b2ed8abeff974bbb0a604349af6f27ea2826a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57ce077c0eebc91b6d06ad93206db43bc788783e6230b0eaee20919519da245a"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # C++17

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
