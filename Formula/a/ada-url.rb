class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/ada-url/ada"
  url "https://github.com/ada-url/ada/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "8b992f0ce9134cb4eafb74b164d2ce2cb3af1900902162713b0e0c5ab0b6acd8"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "91f04f40ba240053b2ba991e6b52668e5f53f3f4b5e04d0abc58bc33b0927b2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d336ca4c0f90426fd502f40ded7346d98e45bf99f5152a59050de66717b2104"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70021323c8ec3859d736153d87c6781b7363a7aaf028d02b71887a64b5734499"
    sha256 cellar: :any_skip_relocation, sonoma:         "6d7a6487df6f4cf80aca1af62121043677e4e045b642d7d14b047588dfa96313"
    sha256 cellar: :any_skip_relocation, ventura:        "e6a4596e5d40dec898078d22e9719c13200498f1a91baa451144ff701590d970"
    sha256 cellar: :any_skip_relocation, monterey:       "2c3f2e749467ec94fb38e19c9666c32030ea42278d140970d70bf096359d4c4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1452b6f3286ea9311f1f642983929727a9b265507094471d6c5ae75e3d19c2f7"
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
