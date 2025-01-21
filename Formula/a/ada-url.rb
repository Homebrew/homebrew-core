class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/ada-url/ada"
  url "https://github.com/ada-url/ada/archive/refs/tags/v2.9.2.tar.gz"
  sha256 "f41575ad7eec833afd9f6a0d6101ee7dc2f947fdf19ae8f1b54a71d59f4ba5ec"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7ee5631616c184991a427c6ccd82b4ae49928524dc61dd21444d5f31c2202421"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1b8a8d3bc904c61fe3b13a2c9ea6cb1627c3b6ff2b139da50c00d5eec2f6344c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a46f54bfb577dc5bfa1431269fa1b93af030640ef7107881fe4f295045fb3475"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a8a04764f60f6857276d5591649367b0c52527d7245248b76b8aaf7992792a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "be0939349107d85265afacf22f9afdba7cccab84023f299f3d3a247e1832b580"
    sha256 cellar: :any_skip_relocation, ventura:        "53d01ad1cacb696ea8313e7e0b559e3b3e124012768a48a9c608c1271ba7355c"
    sha256 cellar: :any_skip_relocation, monterey:       "3235a61e579ec0b15c8b70e57dae70d7b00255e2c2e9fec2844058491f6ec2fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9fbc1dd0f5485a000e353d552aa41b25b8cf355f44c615e7f6533b64b7f0198"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  def install
    system "cmake", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "ada.h"
      #include <iostream>

      int main(int , char *[]) {
        auto url = ada::parse<ada::url_aggregator>("https://www.github.com/ada-url/ada");
        url->set_protocol("http");
        std::cout << url->get_protocol() << std::endl;
        return EXIT_SUCCESS;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++17",
           "-I#{include}", "-L#{lib}", "-lada", "-o", "test"
    assert_equal "http:", shell_output("./test").chomp
  end
end
