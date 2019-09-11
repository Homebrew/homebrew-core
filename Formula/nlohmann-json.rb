class NlohmannJson < Formula
  desc "JSON for modern C++"
  homepage "https://github.com/nlohmann/json"
  url "https://github.com/nlohmann/json/archive/v3.7.0.tar.gz"
  sha256 "d51a3a8d3efbb1139d7608e28782ea9efea7e7933157e8ff8184901efd8ee760"
  head "https://github.com/nlohmann/json.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb63b48d616e8688c5c9309d56230cfeb5380e2f2e9fda094a35d205fd078c58" => :mojave
    sha256 "cb63b48d616e8688c5c9309d56230cfeb5380e2f2e9fda094a35d205fd078c58" => :high_sierra
    sha256 "e2a583453c0f0b530a20bb8ee0b9471a111effc4e42b0cfd14a43ac70b5ba465" => :sierra
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
