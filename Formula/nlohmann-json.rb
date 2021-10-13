class NlohmannJson < Formula
  desc "JSON for modern C++"
  homepage "https://github.com/nlohmann/json"
  url "https://github.com/nlohmann/json/archive/v3.10.3.tar.gz"
  sha256 "e0d7c1b120cac47fa7f14a41d10a5d390f67d423d8e97b9d6834887285d6873c"
  license "MIT"
  head "https://github.com/nlohmann/json.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1e1824588e1a5643207275b23ef42c0f42ed6e28ba133afe3087a03e98e14940"
    sha256 cellar: :any_skip_relocation, big_sur:       "619c80951621c9132a08cec2f8669b3effa5bddd1e2aad89cf8d23896247b763"
    sha256 cellar: :any_skip_relocation, catalina:      "619c80951621c9132a08cec2f8669b3effa5bddd1e2aad89cf8d23896247b763"
    sha256 cellar: :any_skip_relocation, mojave:        "619c80951621c9132a08cec2f8669b3effa5bddd1e2aad89cf8d23896247b763"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8e978ec38d9b6493905e803d5da3d8a7b6752e6f5bdb3100cbae694e21d00ae"
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
