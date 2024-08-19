class JsonC < Formula
  desc "JSON parser for C"
  homepage "https://github.com/json-c/json-c/wiki"
  url "https://github.com/json-c/json-c/archive/refs/tags/json-c-0.17-20230812.tar.gz"
  version "0.17"
  sha256 "024d302a3aadcbf9f78735320a6d5aedf8b77876c8ac8bbb95081ca55054c7eb"
  license "MIT"
  head "https://github.com/json-c/json-c.git", branch: "master"

  livecheck do
    url :stable
    regex(/^json-c[._-](\d+(?:\.\d+)+)(?:[._-]\d{6,8})?$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ba640ce5ab085d32c4a1dd2f631ba8940899f77c9d798ecc6ccc304598cc6ceb"
    sha256 cellar: :any,                 arm64_ventura:  "f06d21bf49bb8378ef1648221ed367e7ead751b84925b255ef0b62f14d1824dc"
    sha256 cellar: :any,                 arm64_monterey: "61480b16756199897acf340e53625706814566dcf89ecf546e267a08397a9f22"
    sha256 cellar: :any,                 arm64_big_sur:  "bf59859457fc4fb5179ade327a515df884730b7ab8002d7f56eec828f0743bb8"
    sha256 cellar: :any,                 sonoma:         "bc18ee5baf0bc8a6738efa43247397b79eea4d0a78898810d8d73c7284ea14c4"
    sha256 cellar: :any,                 ventura:        "6964da23ee0822500168be2c7c15d2709a1c7cf22f9ad8a6fa1f38376ef039bd"
    sha256 cellar: :any,                 monterey:       "2f05628637cfa60d6e03546c490d9a72065c378fe537ccb4b3373f00e7347608"
    sha256 cellar: :any,                 big_sur:        "753822a39038451b42ecac7afc27da1bfc4acacfe1c8d9ac1d9ae0d365d946a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "febcc3f9759d70c935f513a81e3fd9ea637de002fc5be4b2ecc8449160e90920"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
