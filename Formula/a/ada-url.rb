class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/ada-url/ada"
  url "https://github.com/ada-url/ada/archive/refs/tags/v2.7.7.tar.gz"
  sha256 "7116d86a80b79886efbc9d946d3919801815060ae62daf78de68c508552af554"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "44635012980ef6cb70b4a886476ff7a63c4ec9b9f6750b12942ac271b28df244"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff30f58699a644cc0945a8fe89f29d9152f162cd438e434d48a672fe964411dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "959c4694ffea87120c72d0105e229538162b5ce8afb92026d809dcad102a1dd4"
    sha256 cellar: :any_skip_relocation, sonoma:         "abae80bfcdfc244d1b03fec87ff2dead6deb7c5e9427ab469122b829c6ba3c3e"
    sha256 cellar: :any_skip_relocation, ventura:        "4c7730eeebfe5737240d3dcdcffc5d644af9adf33609182c02ab080a03af7e83"
    sha256 cellar: :any_skip_relocation, monterey:       "bbd1fe163cad88fcb37645dcca890c3dde63a8c340c8657ba29c9d7f3085eb26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "458f9e1f1d5d3e6269c0b430431d044eb36fd5557f7a1458ff5e9e40ff57e25b"
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
