class NlohmannJson < Formula
  desc "JSON for modern C++"
  homepage "https://github.com/nlohmann/json"
  url "https://github.com/nlohmann/json/archive/v3.10.2.tar.gz"
  sha256 "081ed0f9f89805c2d96335c3acfa993b39a0a5b4b4cef7edb68dd2210a13458c"
  license "MIT"
  head "https://github.com/nlohmann/json.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d3f508f482a9e5fe699c655d7da573ce2ef67c55cc3c09a60d3acce00ce1dedc"
    sha256 cellar: :any_skip_relocation, big_sur:       "cc0818f8063c5b3f12116ee7d493ce909bb96d07b5f5e6fec82610beeacb9119"
    sha256 cellar: :any_skip_relocation, catalina:      "cc0818f8063c5b3f12116ee7d493ce909bb96d07b5f5e6fec82610beeacb9119"
    sha256 cellar: :any_skip_relocation, mojave:        "cc0818f8063c5b3f12116ee7d493ce909bb96d07b5f5e6fec82610beeacb9119"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28f8f2061fa9a1a794a58662fbf50e206c3b8db86df16430ec660e4ebf3cbe23"
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
