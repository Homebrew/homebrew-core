class NlohmannJson < Formula
  desc "JSON for modern C++"
  homepage "https://github.com/nlohmann/json"
  url "https://github.com/nlohmann/json/archive/v3.7.0.tar.gz"
  sha256 "d51a3a8d3efbb1139d7608e28782ea9efea7e7933157e8ff8184901efd8ee760"
  head "https://github.com/nlohmann/json.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "a1f0ef0b4ad6f160936a31eb6c2ac4344d25483d9a2e85e9c1b9f0b551d52911" => :mojave
    sha256 "a1f0ef0b4ad6f160936a31eb6c2ac4344d25483d9a2e85e9c1b9f0b551d52911" => :high_sierra
    sha256 "6550e6790dea47b3af4cbb4b91ef3361612ecf20c46d635807443d71772c8ba8" => :sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DJSON_BuildTests=OFF", *std_cmake_args
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
