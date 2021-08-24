class NlohmannJson < Formula
  desc "JSON for modern C++"
  homepage "https://github.com/nlohmann/json"
  url "https://github.com/nlohmann/json/archive/v3.10.1.tar.gz"
  sha256 "c35d8c867f7cde3f6100c3f5dbe999667f77f075cd802bbd37080bd63ceb94c4"
  license "MIT"
  head "https://github.com/nlohmann/json.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c653cd6368c1961f1ce2df22ba32d58dc4d4ef3df480faa423cd618163d3a31b"
    sha256 cellar: :any_skip_relocation, big_sur:       "e1049c7ed41a81e1c6476ae65434a09b15d8c1c13bc6fc63034423db1a888069"
    sha256 cellar: :any_skip_relocation, catalina:      "e1049c7ed41a81e1c6476ae65434a09b15d8c1c13bc6fc63034423db1a888069"
    sha256 cellar: :any_skip_relocation, mojave:        "e1049c7ed41a81e1c6476ae65434a09b15d8c1c13bc6fc63034423db1a888069"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5838bd0f3a6fe6fbfc9b887da10c9d07579c4d4b1c434ea2f670b129577e343"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DJSON_BuildTests=OFF", "-DJSON_MultipleHeaders=ON", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <iostream>
      #include <nlohmann/json.hpp>

      using nlohmann::json;

      int main() {
        json j = {
          {"pi", 3.141},
          {"name", "Niels"},
          {"list", {1, 0, 2}},
          {"object", {
            {"happy", true},
            {"nothing", nullptr}
          }}
        };
        std::cout << j << std::endl;
      }
    EOS

    system ENV.cxx, "test.cc", "-I#{include}", "-std=c++11", "-o", "test"
    std_output = <<~EOS
      {"list":[1,0,2],"name":"Niels","object":{"happy":true,"nothing":null},"pi":3.141}
    EOS
    assert_match std_output, shell_output("./test")
  end
end
