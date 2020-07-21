class JsonC < Formula
  desc "JSON parser for C"
  homepage "https://github.com/json-c/json-c/wiki"
  url "https://github.com/json-c/json-c/archive/json-c-0.14-20200419.tar.gz"
  version "0.14"
  sha256 "ec4eb70e0f6c0d707b9b1ec646cf7c860f4abb3562a90ea6e4d78d177fd95303"
  license "MIT"
  head "https://github.com/json-c/json-c.git"

  bottle do
    cellar :any
    sha256 "50a8093fa52bf5a78391eaaede3565bd94769739bcb638ead50ef8ce5f36bd03" => :catalina
    sha256 "8555eff999bab67ad77f403902e2a4410fa5d55f53d808218d677d08f7fcc9a1" => :mojave
    sha256 "0d34251aac5183c121629d4a2506697d91cb56aac3ca247002594b6ac4054d96" => :high_sierra
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
