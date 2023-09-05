class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/ada-url/ada"
  url "https://github.com/ada-url/ada/archive/refs/tags/v2.6.5.tar.gz"
  sha256 "3c6086b52d9596a0363290c82c59068d04d13b96c6b770966a6d1b3d394b4ad9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e197556b8885bc2e17a97d85dba7418f0b0d0c257904a48e0f0655d2db8565e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad82fc3d88f0751ae690a8f145f73b8a604d9f72d6df5a250fbf4601040178a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "515cac0cdc41f35010d9e8ef5a00d97d73d19f3c40f474a694440f91aec1fcd5"
    sha256 cellar: :any_skip_relocation, ventura:        "882dbf7447013a032ff4da1608d4e2d7a5f2e7a81ccfddbd21698f31d600d40e"
    sha256 cellar: :any_skip_relocation, monterey:       "55c79cd5e9f6a06f59f1cffea1646e4a89c09f1d12517dc43ff49212ef40b76c"
    sha256 cellar: :any_skip_relocation, big_sur:        "3fc7f566d31b92790af6767acc65a03272016ec629d899e1ca46e023b83ff5aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79ab9faff9a530d052cb0d5f47e12267824e2dfb764b51c964b80b0caf83a2fc"
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
