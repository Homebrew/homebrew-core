class NlohmannJson < Formula
  desc "JSON for modern C++"
  homepage "https://github.com/nlohmann/json"
  url "https://github.com/nlohmann/json/archive/v3.10.2.tar.gz"
  sha256 "081ed0f9f89805c2d96335c3acfa993b39a0a5b4b4cef7edb68dd2210a13458c"
  license "MIT"
  head "https://github.com/nlohmann/json.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "190726aa370eacf7e7b418efc4f41dba00cfb253000e1619c13c89c8c08a3ecf"
    sha256 cellar: :any_skip_relocation, big_sur:       "3b94c66d7a17f26bb1de9fb6b6461c356d831960c49acd3571b423c263c8c262"
    sha256 cellar: :any_skip_relocation, catalina:      "3b94c66d7a17f26bb1de9fb6b6461c356d831960c49acd3571b423c263c8c262"
    sha256 cellar: :any_skip_relocation, mojave:        "3b94c66d7a17f26bb1de9fb6b6461c356d831960c49acd3571b423c263c8c262"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c08cbe8bf45f4b832fef7470051b7930795f8c119e732573f641dc1495ede673"
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
