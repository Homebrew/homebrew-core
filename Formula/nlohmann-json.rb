class NlohmannJson < Formula
  desc "JSON for modern C++"
  homepage "https://github.com/nlohmann/json"
  url "https://github.com/nlohmann/json/archive/v3.10.4.tar.gz"
  sha256 "1155fd1a83049767360e9a120c43c578145db3204d2b309eba49fbbedd0f4ed3"
  license "MIT"
  head "https://github.com/nlohmann/json.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5e8791f898a91aba28ea778847695067e46942730be69c8af4383919f5244a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5e8791f898a91aba28ea778847695067e46942730be69c8af4383919f5244a3"
    sha256 cellar: :any_skip_relocation, monterey:       "9534eff1c002ce96b04b73bec07725e7be801b9677ea7caf167e3a7fec4bdccb"
    sha256 cellar: :any_skip_relocation, big_sur:        "9534eff1c002ce96b04b73bec07725e7be801b9677ea7caf167e3a7fec4bdccb"
    sha256 cellar: :any_skip_relocation, catalina:       "9534eff1c002ce96b04b73bec07725e7be801b9677ea7caf167e3a7fec4bdccb"
    sha256 cellar: :any_skip_relocation, mojave:         "9534eff1c002ce96b04b73bec07725e7be801b9677ea7caf167e3a7fec4bdccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b30492367ffd6f5637b2458b01011e1f139d2270e6f547bd905654503fc24ce"
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
