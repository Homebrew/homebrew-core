class JsonC < Formula
  desc "JSON parser for C"
  homepage "https://github.com/json-c/json-c/wiki"
  url "https://s3.amazonaws.com/json-c_releases/releases/json-c-0.19.tar.gz"
  sha256 "37ad0249902e301bd9052bf712e511fcc6acff4ecaad4b5900aad9ce564e26de"
  license "MIT"
  head "https://github.com/json-c/json-c.git", branch: "master"

  livecheck do
    url :head
    regex(/^json-c[._-](\d+(?:\.\d+)+)(?:[._-]\d{6,8})?$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4095feba36f7d453ae23ddb2656038e0784e857e1c860e70fe26a7c5089c36f5"
    sha256 cellar: :any, arm64_sequoia: "760e09935d633a49e8a25121969022ef158eed40b739bd142063aadbfed41730"
    sha256 cellar: :any, arm64_sonoma:  "5400fe0c0a10ad922569ca98c24aad93feb3941509ba16e89658e252d4b8c7f1"
    sha256 cellar: :any, sonoma:        "616cd6df4b887c15fbe14f1b8e15a1832d0e7790152bd5ae5c6469c896d96fae"
    sha256 cellar: :any, arm64_linux:   "7f7efa6004df5536485af1f41d96ee65b395e6c3c55a1a4e18e41ff68df6efbe"
    sha256 cellar: :any, x86_64_linux:  "4d85c99fb83f7bdda0f79118df9605db6bfb1a0e4bfac02ffccddc645c1991d3"
  end

  depends_on "cmake" => :build

  def install
    # We pass `BUILD_APPS=OFF` since any built apps are never installed. See:
    #   https://github.com/json-c/json-c/blob/master/apps/CMakeLists.txt#L119-L121
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_APPS=OFF", *std_cmake_args
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
