class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/ada-url/ada"
  url "https://github.com/ada-url/ada/archive/refs/tags/v2.7.8.tar.gz"
  sha256 "8de067b7cb3da1808bf5439279aee6048d761ba246bf8a854c2af73b16b41c75"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6069af3707acd9e523460a9020601f71f28d6056f7e776bd64698ef55ff3ac20"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49d1b7f782eb6c1372b89634164013099f67a70a4e886377ba02d3863b93f6c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "054d1e93634e45d4818d5cb378ee6df0e86ce82da0e1fbceefbdd066b10e7791"
    sha256 cellar: :any_skip_relocation, sonoma:         "59e8451e2af9891e3a4b7e45c22359e5489ff2c01b59f4e5c5a4a6416d4b0a1d"
    sha256 cellar: :any_skip_relocation, ventura:        "e258e3d8920b1c45af3dc11e761ac3e5e2ac1f5585a63880461c3eb0e57409dd"
    sha256 cellar: :any_skip_relocation, monterey:       "4bbc60dbde13d1db2fa4d656594193766900cf21f988344738045bb267fe272c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "642216f0d6fef13616b1142b04b7a200ba7814d771619f13566f776c52e15c7e"
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
