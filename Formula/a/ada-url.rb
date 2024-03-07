class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/ada-url/ada"
  url "https://github.com/ada-url/ada/archive/refs/tags/v2.7.7.tar.gz"
  sha256 "7116d86a80b79886efbc9d946d3919801815060ae62daf78de68c508552af554"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a187c2505b5b28e3d4f4eb2568a109f2cb6b8c5ba4c79f309fdbc4cf347d2f58"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b91d0d62e84ef7814d3850af3f955f071c0cb416e8075d56d20c295a75336de3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57eb3306747e53c70484e0f5bfb84441b81883d8187ddff4af745ad72272705f"
    sha256 cellar: :any_skip_relocation, sonoma:         "a996328b134176eac870a552b1d6d08419adf8f9e51608df21bb4b064a8491e4"
    sha256 cellar: :any_skip_relocation, ventura:        "3b371177d94a20edb844be71ccfde6b9dfcd8fb73fe4c14aaef6abd7b536384f"
    sha256 cellar: :any_skip_relocation, monterey:       "f3f204ebd86565e71ee585a64667ed93ac0ef01b3614043b43856ba796a11231"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28b8d4d61d8e25041fa1aa4596e4e9a3827c589a0bf7ede0f74d9d01062522a7"
  end

  depends_on "cmake" => :build
  depends_on "python@3.12" => :build
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
