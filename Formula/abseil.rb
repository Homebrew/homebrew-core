class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://github.com/abseil/abseil-cpp/archive/20210324.2.tar.gz"
  sha256 "59b862f50e710277f8ede96f083a5bb8d7c9595376146838b9580be90374ee1f"
  license "Apache-2.0"
  head "https://github.com/abseil/abseil-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "e6f4665315350736b5cd574f4316ebba4d10cfeda0531602f358c1c013ae9256"
    sha256 cellar: :any,                 big_sur:       "75980931b499a49b4294b57b6a2c664258758f55255b8733bdfbd9c97df7d9c7"
    sha256 cellar: :any,                 catalina:      "d0d9a804df91a4a70f5eec48ae7f434bb71befe5e9e48f7ac6a93322f5397453"
    sha256 cellar: :any,                 mojave:        "dec3e39d5010921e76890d4d7343eb777715784f5d6d218329a768707f585f87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "346f592e8d302b18fc688cdf4134a1b1879991c8789eec8214375d6439af25eb"
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
