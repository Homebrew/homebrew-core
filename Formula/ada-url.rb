class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/ada-url/ada"
  url "https://github.com/ada-url/ada/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "a7591d771822c3f16e6665311b0c6b4de7dd7615333183f35d89c7573be7f7fa"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e2ba55322080e0e6cf9232c84367c7e0c12930e1a51f2a046b7588020ead2ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c3c33f147f80c555c71f1cc9b17a21536f4e52ab34fe10a5fc5138e94eb2e91"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ff760f970718322d29c48ef89d055581502b13203f1afac0ced0151772f25be"
    sha256 cellar: :any_skip_relocation, ventura:        "3e1c849103cda3647577ecea043dc285ed3ac0ba7c14c01f4e573106ee191cc4"
    sha256 cellar: :any_skip_relocation, monterey:       "ed26335809f8c0ed0f78abaec63bb98c106d2767b737d060f5e6f36e4a8f556a"
    sha256 cellar: :any_skip_relocation, big_sur:        "148db0d832a9a81fc4ce2914ffdcf183c69beb19f0ffaaea9983c7014796fe50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6d71a641971fa2dbd410db4c90f6929f8dbdd5cd0b96b17d99b64ebc201903c"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build
  depends_on macos: :catalina

  def install
    system "cmake", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "ada.h"
      #include <iostream>

      int main(int , char *[]) {
        auto url = ada::parse<ada::url_aggregator>("https://www.github.com/ada-url/ada");
        url->set_protocol("http");
        std::cout << url->get_protocol() << std::endl;
        return EXIT_SUCCESS;
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++17",
           "-I#{include}", "-L#{lib}", "-lada", "-o", "test"
    assert_equal "http:", shell_output("./test").chomp
  end
end
