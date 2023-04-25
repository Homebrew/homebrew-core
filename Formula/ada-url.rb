class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/ada-url/ada"
  url "https://github.com/ada-url/ada/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "40a6b3fe0d5c62936c081e8403790ec05d5afe3d0909eece894efcfef7e678ee"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91e7fb5529261a76dc13bd98965cdce43535402a40442175635c38e3ab6619fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c64b387f0b9b5f5e0fad6a687fb9eb5722e7c8d207584b207034f8a89f20f017"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "682af68ceb87ade33e2ddd6c1ae018c636908d51cfc83cb11ed0444ed21581f6"
    sha256 cellar: :any_skip_relocation, ventura:        "d408d68007082402d7ab01034a9e748492dd88904d1420e50c7454a73f0f8057"
    sha256 cellar: :any_skip_relocation, monterey:       "d68cd2915323c08b2f1fd51f36ad8475baf4e464c931f14b86bbc9acdff77fce"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a73d91c6217e556ac6e9f76dd16497d178d5c6d16f109a8a2c4067c4483666f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96a9453bcafc9c26c203b1b9490ad01ed04d9ee7f21973f8262ca578dd2a081a"
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
