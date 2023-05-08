class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/ada-url/ada"
  url "https://github.com/ada-url/ada/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "298992ec0958979090566c7835ea60c14f5330d6372ee092ef6eee1d2e6ac079"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6725ace5661fbcfb00ceabcfb50801b42a14dc30137e9e3f4ffa948f3b4b6ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bc81a5d58e291b6c8946949266ddde7cf8d39e2d06d59bcc727968a81833f90"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "229a692f3981b15307850cf09f70e532b1b54e8d3962dda6518512ab4cdbc89c"
    sha256 cellar: :any_skip_relocation, ventura:        "caf2c7cb44884c5210531999015be80943f1e836b34c825f879325aa088d3f9c"
    sha256 cellar: :any_skip_relocation, monterey:       "c8ef172bf85f9f3e0560298aa9b79fb7422211a2d7c82a52e32917aaffe52288"
    sha256 cellar: :any_skip_relocation, big_sur:        "f540dbabd3ca8adecd1be083c9eb859a747a57e38e21b9fdc7de32608bc7a69c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "656bc9fd6ebaad9f010c6861642f0e31e88e5592c08ac82a827f48d1b15a1186"
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
