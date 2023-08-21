class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/ada-url/ada"
  url "https://github.com/ada-url/ada/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "09551bfbd92853e59d731e5f44a88a690425fd2906977ad03a6a1059615a02a5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ec07f532ccc837bbe6196090f2ac2c441d6a2984545a3ca157d4ab71f6c76a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd216301e44a6151556ce5516c9c2c66f173a9eb6f430fc9babee747788b3652"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae3d248605c4a27a1a10a7687a3707690f0f47469dfb8a92a4995126609b72df"
    sha256 cellar: :any_skip_relocation, ventura:        "e09bf2f78250e9f30e84e433597e736432e90d4d59d33fb87ae650d24d71e6e6"
    sha256 cellar: :any_skip_relocation, monterey:       "27eb45aa96ab95706ffb2604ec98ed473dee0b338b63a669fcff0bbca3dbe691"
    sha256 cellar: :any_skip_relocation, big_sur:        "6cd12a9990a40ded4b1a44ee64412d13a72b50179b32fcee9e5be9b0826a709d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9dad115d0ee0f5b1e652faa6f10bb8f63f9196a1d0dfec361dbd21392a3a9ddc"
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
