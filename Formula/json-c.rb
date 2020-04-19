class JsonC < Formula
  desc "JSON parser for C"
  homepage "https://github.com/json-c/json-c/wiki"
  url "https://github.com/json-c/json-c/archive/json-c-0.14-20200419.tar.gz"
  version "0.14"
  sha256 "ec4eb70e0f6c0d707b9b1ec646cf7c860f4abb3562a90ea6e4d78d177fd95303"
  head "https://github.com/json-c/json-c.git"

  bottle do
    cellar :any
    sha256 "40a0c602bbc055eabd9a8be69fbf43f7e5b83a7b3b346581574f20e0b97e558a" => :catalina
    sha256 "9282e683104df6ee6cf495821de87a9badab080dfdcace1e631e518328e302d9" => :mojave
    sha256 "4f51e5ad713e467d1df189c8b594c7e9ae279ed4fc2b0a8d1b328a3c258135d7" => :high_sierra
    sha256 "279d88326f2f6aff9faf0c593ae4173c058e07ba0523f73107dfcbef3b54bd45" => :sierra
    sha256 "724bffe043ecc73611fb4e7b2fcefbe35cb8b3a64aabf5cec92d43938b8e02d3" => :el_capitan
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
