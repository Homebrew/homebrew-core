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
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "6b45746f31780a84ae3ed11d056bd101d1b0a6d0f16bf91aad2d35a18f6107dc"
    sha256 cellar: :any, arm64_tahoe:       "f2da9c816501d9c3c0e5f883b60b3d2758b35a3995e20d541d4b029d8b35ef13"
    sha256 cellar: :any, arm64_sequoia:     "5624048dbb067f1a6d3784081029c3d738edeefd57188ce6724bb93d01aa53aa"
    sha256 cellar: :any, arm64_sonoma:      "ce9c5f6c7095110cd5c9336b9277e1845cc55bb0fc98c7550576587fd28abbb1"
    sha256 cellar: :any, arm64_linux:       "64475f64c83a75a0438e4d652bd75b0e7428f2e33e33377c88f087f4c652ed90"
    sha256 cellar: :any, x86_64_linux:      "9745b482f9c14d66b5ec02f567a61f7ef29f9060cded74e5b37e322c139580af"
  end

  depends_on "cmake" => :build

  deny_network_access!

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
