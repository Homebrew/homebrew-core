class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/ada-url/ada"
  url "https://github.com/ada-url/ada/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "83b77fb53d1a9eea22b1484472cea0215c50478c9ea2b4b44b0ba3b52e07c139"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cad49d7fd4d01b870e9af61566af3ab8dddca077c96a008d19d1f0df3ec4b4ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4e0f57e32280efb6b4e379bda3caadb7fa42ab195ca247afb83a3afbfcf32af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb0dd3c503a1c9cda31bf609c3abb2b7642536cded82456f8492da57fc8e2117"
    sha256 cellar: :any_skip_relocation, sonoma:         "c64f62325aa7d111f80099242a34d25332d5f6f446a5da24ac10fb0f11d6eb79"
    sha256 cellar: :any_skip_relocation, ventura:        "596f40c35badfd78e0184d5c79b48bb6a53bd7ad44d9d13ee67673c990cd4455"
    sha256 cellar: :any_skip_relocation, monterey:       "c8600ce8290e72fa28bfa9049cee9e84bd8c5881e530f2cb210d9e92bc2ed42e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfe35897d3ec1f47ccd47483258d2720bc407e1ab8a752939497dc1caebb7131"
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
