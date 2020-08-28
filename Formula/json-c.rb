class JsonC < Formula
  desc "JSON parser for C"
  homepage "https://github.com/json-c/json-c/wiki"
  url "https://github.com/json-c/json-c/archive/json-c-0.15-20200726.tar.gz"
  version "0.15"
  sha256 "4ba9a090a42cf1e12b84c64e4464bb6fb893666841d5843cc5bef90774028882"
  license "MIT"
  head "https://github.com/json-c/json-c.git"

  livecheck do
    url :head
    regex(/^json-c[._-](\d+(?:\.\d+)+)(?:[._-]\d{6,8})?$/i)
  end

  bottle do
    cellar :any
    sha256 "60d15ece3fb1fdc8722785de8243c2261222f674e998509375522a1de75497ea" => :catalina
    sha256 "6ab7f776315184769ed74115f614996401eae4577c36144ba4cdd1d41427d0cf" => :mojave
    sha256 "a211a34a52b452386cf6e23f8f27cc9d088e64d2793bae7a4b3a7a069d31a88a" => :high_sierra
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
    system ENV.cc, "-I#{include}", "-L#{lib}", "-ljson-c", "test.c", "-o", "test"
    assert_equal '{ "key": "value" }', shell_output("./test").chomp
  end
end
