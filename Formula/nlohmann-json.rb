class NlohmannJson < Formula
  desc "JSON for modern C++"
  homepage "https://github.com/nlohmann/json"
  url "https://github.com/nlohmann/json/archive/v3.7.3.tar.gz"
  sha256 "249548f4867417d66ae46b338dfe0a2805f3323e81c9e9b83c89f3adbfde6f31"
  head "https://github.com/nlohmann/json.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "fce41a929a18c6d2f11d7991d41cbea065896b7bd33340d00246f134f267181b" => :catalina
    sha256 "fce41a929a18c6d2f11d7991d41cbea065896b7bd33340d00246f134f267181b" => :mojave
    sha256 "fce41a929a18c6d2f11d7991d41cbea065896b7bd33340d00246f134f267181b" => :high_sierra
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
