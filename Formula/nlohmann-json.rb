class NlohmannJson < Formula
  desc "JSON for modern C++"
  homepage "https://github.com/nlohmann/json"
  url "https://github.com/nlohmann/json/archive/v3.7.1.tar.gz"
  sha256 "e25cf46631f1a3200d109ca33a683b84538411170ee99cd181db8089a2513189"
  head "https://github.com/nlohmann/json.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "d9478eb26e55b57b01eee1b48de1b0a1746ac76bfa279aa452c8ae9aebcccc08" => :catalina
    sha256 "d9478eb26e55b57b01eee1b48de1b0a1746ac76bfa279aa452c8ae9aebcccc08" => :mojave
    sha256 "d9478eb26e55b57b01eee1b48de1b0a1746ac76bfa279aa452c8ae9aebcccc08" => :high_sierra
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
