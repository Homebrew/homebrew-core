class JsonC < Formula
  desc "JSON parser for C"
  homepage "https://github.com/json-c/json-c/wiki"
  url "https://github.com/json-c/json-c/archive/json-c-0.15-20200726.tar.gz"
  version "0.15"
  sha256 "4ba9a090a42cf1e12b84c64e4464bb6fb893666841d5843cc5bef90774028882"
  license "MIT"
  head "https://github.com/json-c/json-c.git"

  livecheck do
    url :stable
    regex(/^json-c[._-](\d+(?:\.\d+)+)(?:[._-]\d{6,8})?$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "aa77c8ba78da4835aafa77385d9e8c83b7dab9b460588929233b76a895d5c155"
    sha256 cellar: :any,                 arm64_big_sur:  "cfe16365846be7c8bbbab9cf5eaea4edc861f2174b37b9cc520d6dd0023c23d8"
    sha256 cellar: :any,                 monterey:       "097370067c260978acbb58f7f14f0435a74246fce130615ec80c107cca9e7d17"
    sha256 cellar: :any,                 big_sur:        "11990ad17649041f31c96e7c383e9eb6a8e1cd7491c0ff9a8ee89ab66d2a11ba"
    sha256 cellar: :any,                 catalina:       "60d15ece3fb1fdc8722785de8243c2261222f674e998509375522a1de75497ea"
    sha256 cellar: :any,                 mojave:         "6ab7f776315184769ed74115f614996401eae4577c36144ba4cdd1d41427d0cf"
    sha256 cellar: :any,                 high_sierra:    "a211a34a52b452386cf6e23f8f27cc9d088e64d2793bae7a4b3a7a069d31a88a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e09dc03017ac91fe1b6db9c6e5ec2c580dd7ce72ba91ba46422f51b3e236d004"
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
