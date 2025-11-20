class NlohmannJson < Formula
  desc "JSON for modern C++"
  homepage "https://json.nlohmann.me/"
  url "https://github.com/nlohmann/json/archive/refs/tags/v3.12.0.tar.gz"
  sha256 "4b92eb0c06d10683f7447ce9406cb97cd4b453be18d7279320f7b2f025c10187"
  license "MIT"
  head "https://github.com/nlohmann/json.git", branch: "develop"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "df65065eb8504f15f8802b7c681df015a592a68336db7fe290eeeda59fa1e440"
  end

  depends_on "cmake" => :build

  # Fix to error: unknown type name 'char8_t' for clang, remove in next release
  # PR ref: https://github.com/nlohmann/json/pull/4736
  patch do
    url "https://github.com/nlohmann/json/commit/34868f90149de02432ea758a29227a6ad74f098c.patch?full_index=1"
    sha256 "fb4db3640ce333b145b53acc64c78eb3011f57012dc4b9c6689d5d485d2434cd"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DJSON_BuildTests=OFF", "-DJSON_MultipleHeaders=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~CPP
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
    CPP

    system ENV.cxx, "test.cc", "-I#{include}", "-std=c++11", "-o", "test"
    std_output = <<~JSON
      {"list":[1,0,2],"name":"Niels","object":{"happy":true,"nothing":null},"pi":3.141}
    JSON
    assert_match std_output, shell_output("./test")
  end
end
