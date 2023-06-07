class JsonC < Formula
  desc "JSON parser for C"
  homepage "https://github.com/json-c/json-c/wiki"
  url "https://github.com/json-c/json-c/archive/refs/tags/json-c-0.16-20220414.tar.gz"
  version "0.16"
  sha256 "3ecaeedffd99a60b1262819f9e60d7d983844073abc74e495cb822b251904185"
  license "MIT"
  head "https://github.com/json-c/json-c.git", branch: "master"

  livecheck do
    url :stable
    regex(/^json-c[._-](\d+(?:\.\d+)+)(?:[._-]\d{6,8})?$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cad45d82dc941532f7863eeca9a355764f5976b3d772ab2fa3b5a1e0a7a626c5"
    sha256 cellar: :any,                 arm64_monterey: "0f71590b7e5045f6c8c892527a7f6f3e7d3b5d7cf0f43b93cf50bf662cdd84f2"
    sha256 cellar: :any,                 arm64_big_sur:  "efc09489ecb843511393e5166d8351ab8bf3c5e263d91a5838735b574e8dd4e7"
    sha256 cellar: :any,                 ventura:        "98957cbd34b40da1964eaf3a7b35271e46c7d5c62c69d2dfadf1001d40f63042"
    sha256 cellar: :any,                 monterey:       "2d032280aa3e434671354c91a191b865f8de9290f5f8fba2336cac88037c1f33"
    sha256 cellar: :any,                 big_sur:        "e31bc0e529950442ccc42719107e14de5e995847f8abab34f0961d19d9d45976"
    sha256 cellar: :any,                 catalina:       "425524c4c8a10f50da278278e624b4dce61ff94f464511095d30a17a3bea68ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afd62a8176c2684a0385f921312805e17b8c85db63a617266e24ec7b93488563"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~'EOS'
      #include <stdio.h>
      #include <json-c/json.h>

      int main() {
        json_object *obj = json_object_new_object();
        json_object *value = json_object_new_string("value");
        json_object_object_add(obj, "key", value);
        printf("%s\n", json_object_to_json_string(obj));
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "test.c", "-L#{lib}", "-ljson-c", "-o", "test"
    assert_equal '{ "key": "value" }', shell_output("./test").chomp
  end
end
