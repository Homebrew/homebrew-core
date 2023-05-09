class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/ada-url/ada"
  url "https://github.com/ada-url/ada/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "14624f1dfd966fee85272688064714172ff70e6e304a1e1850f352a07e4c6dc7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc9a77caea0f183cf65cc34e6839171df7cd682d3976df171614d8652c0a886c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2922123f96f592785832f48307b91fc6f6f4c7ab5517ce6028fee552189cb259"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "416624d3eef453e046cad66cbe05ef80623054c7165474bdc33e353033e20aee"
    sha256 cellar: :any_skip_relocation, ventura:        "d5ab5bf07efbe2b09d524b369e1edcc4406cb4619767e58943d3c64f8fb3cb6b"
    sha256 cellar: :any_skip_relocation, monterey:       "c05b34e3e6493d624ed81e73f2cee9884d90e6d2781b508463aa8d6a86fed36b"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3cfc53f69cfa3f1d95fd725aba770fe60d984c5b9857a73153185600cf03303"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ace6fdc13ff2c381cc918c63cccafb38016dc8106675f875355186edc9a95899"
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
