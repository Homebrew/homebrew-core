class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/ada-url/ada"
  url "https://github.com/ada-url/ada/archive/refs/tags/v2.6.8.tar.gz"
  sha256 "c3cc83ea57f89e93520674c8e7fdd884d6ea95fec48419f1a2b481e1a4f6b71e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eaeaa602d1ad50cb198337f880dd3b36c689df038cc6ceba9aed889fc2dfc41e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6a051b6351a1a426c660aa2c964613fe5d96e437d62dffe1cd8b38def8a22d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7e3189f50c5e7de8f1fde8071a973c37fa55c95af404de77bbe10db98269753"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7abe6a3c7588373d3f6710fe64de97056f902cbf8003acd2ef5d18f8e2998d87"
    sha256 cellar: :any_skip_relocation, sonoma:         "85cb1f20206511c639bd044fc848d3d585127b53c6d52b1af068e23fcf6d853e"
    sha256 cellar: :any_skip_relocation, ventura:        "65a3aff8807f5ddbc012af632dacabba6e0f0e4f653e2eae7b28369cf46efb1f"
    sha256 cellar: :any_skip_relocation, monterey:       "8cb106b98714ebfb505ca3b9f0923b06f0d504d18b29f6fe3ae8ebc1cb9e6da5"
    sha256 cellar: :any_skip_relocation, big_sur:        "aaf587ceac35f3faf10a3bc1039a3c06e03c0ae0df66fabb0d27853ea6d79585"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c570a129d1ce04d898ae556bb7aa9eb3b9bf447f04297b7ff37fae64bdb4858"
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
