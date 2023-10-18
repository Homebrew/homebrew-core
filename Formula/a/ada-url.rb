class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/ada-url/ada"
  url "https://github.com/ada-url/ada/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "08646b8a41cd6367b282aab2c87c82e5ce4876078a0cbe0799af7e51e4358591"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a58d55efbc46b59934dd93deaeabb99f2d3488d8d6005e35777e381e3797bbc4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "705a345c358b26d80811836e84b7f7edced6463de31d315910e761bb8763628d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a65361b8218fa8c0d36ddafadbb7e4f0c786dc3ef6d30f6b68c81c29902a17ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "d149c3ad4e28577ffa1597b2b6f4c9531a9c74466966de4df3c06938a4bda162"
    sha256 cellar: :any_skip_relocation, ventura:        "86cb6b83ac258dfe0d7406e943ac9aeafa757291ad351e193891fe58de4dc7d7"
    sha256 cellar: :any_skip_relocation, monterey:       "e20b008860aa65d19992db820d6c50225354b118a49faa181a13685e1e2fec4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15753c87c8c03870ce78804bbbf5978b4abbc35c0176e262e24ad4e02bce9c69"
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
