class NlohmannJson < Formula
  desc "JSON for modern C++"
  homepage "https://github.com/nlohmann/json"
  url "https://github.com/nlohmann/json/archive/v3.9.0.tar.gz"
  sha256 "9943db11eeaa5b23e58a88fbc26c453faccef7b546e55063ad00e7caaaf76d0b"
  license "MIT"
  head "https://github.com/nlohmann/json.git", branch: "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "e85ad4d705eeb69b1d4b49a5fceea83ac7965aab137028422f97ad5a5889f6ac" => :catalina
    sha256 "02d729ed211ff251135b13c81fe4847e74a699e3560ef1b204164f5a4b10ac95" => :mojave
    sha256 "02d729ed211ff251135b13c81fe4847e74a699e3560ef1b204164f5a4b10ac95" => :high_sierra
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
