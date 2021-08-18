class NlohmannJson < Formula
  desc "JSON for modern C++"
  homepage "https://github.com/nlohmann/json"
  url "https://github.com/nlohmann/json/archive/v3.10.0.tar.gz"
  sha256 "eb8b07806efa5f95b349766ccc7a8ec2348f3b2ee9975ad879259a371aea8084"
  license "MIT"
  head "https://github.com/nlohmann/json.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "34d7a9adeccba3105b55c432d4587e511802996829ffd5aed62f7db9c4e73047"
    sha256 cellar: :any_skip_relocation, big_sur:       "f8a76b68eaf9a0aa8f6e9ccd8eceadaaea2e428c7e30a73e215a32fe1b62d009"
    sha256 cellar: :any_skip_relocation, catalina:      "b541218f118a50a5f95f7f3650e520be58398619bbc6073d7b36cb320bf212c7"
    sha256 cellar: :any_skip_relocation, mojave:        "fe00728aa85f032016788a0ec770b47a0e8e4b7cf2fc1547aa4ecf774bf1028c"
    sha256 cellar: :any_skip_relocation, high_sierra:   "43b0bfd3b8d202358ab4141a01a11588f1b90c9ecf0a71c5764d97ac546f5fde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "319e7299d8378d957e23ead85e67f0cb4841ad0c63bdc092d50566ac3d5a05a7"
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
      #include <nlohmann/json.hpp>

      using nlohmann::json;

      int main() {
        // create an empty structure (null)
        json j;

        // add a number that is stored as double (note the implicit conversion of j to an object)
        j["pi"] = 3.141;

        // add a Boolean that is stored as bool
        j["happy"] = true;

        // add a string that is stored as std::string
        j["name"] = "Niels";

        // add another null object by passing nullptr
        j["nothing"] = nullptr;

        // add an object inside the object
        j["answer"]["everything"] = 42;

        // add an array that is stored as std::vector (using an initializer list)
        j["list"] = { 1, 0, 2 };

        // add another object (using an initializer list of pairs)
        j["object"] = { {"currency", "USD"}, {"value", 42.99} };

        // instead, you could also write (which looks very similar to the JSON above)
        json j2 = {
          {"pi", 3.141},
          {"happy", true},
          {"name", "Niels"},
          {"nothing", nullptr},
          {"answer", {
            {"everything", 42}
          }},
          {"list", {1, 0, 2}},
          {"object", {
            {"currency", "USD"},
            {"value", 42.99}
          }}
        };

        // a user-defined literal
        json j3 = R"(
          {
            "pi": 3.141,
            "happy": true,
            "name": "Niels",
            "nothing": null,
            "answer": {
              "everything": 42
            },
            "list": [1, 0, 2],
            "object": {
              "currency": "USD",
              "value": 42.99
            }
          }
        )"_json;
      }
    EOS

    system ENV.cxx, "test.cpp", "-I#{include}", "-std=c++11", "-o", "test"
    system "./test"
  end
end
