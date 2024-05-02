class Open62541 < Formula
  desc "Open source implementation of OPC UA"
  homepage "https://open62541.org/"
  url "https://github.com/open62541/open62541/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "22a7a1f821b26f541feb96cc5879e0c76cb3b968e508209b5bf98f2869b11a89"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2a74d2a9c568cd1a23b977397a318b2f22d36032a74f45699c84c1cb590f6016"
    sha256 cellar: :any,                 arm64_ventura:  "724e7e39ec00121936a88bd0821ba8e72ff4d2aa0f03b9662a92c2d8c43b7ae3"
    sha256 cellar: :any,                 arm64_monterey: "0937d542b8c22ccf6fc4fd12f5cc8fd75293a4a6f3498c46be3d9c0f4c29bd26"
    sha256 cellar: :any,                 sonoma:         "4bd9d351596548ebc7d20944d1407cf14fc562d233c65a8f82e2d3334a0d68aa"
    sha256 cellar: :any,                 ventura:        "31feecdc1c7976effd1ba11c0f64f9d9968643eed7d640c3674f1b85c34a1adb"
    sha256 cellar: :any,                 monterey:       "e368d2a4819ce8580b6c21a2c2d0de7f163ca671353b18b3a389a6a2bb85394c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3fea3a886fe38f7a167def25b79d3fa065aae6094178aaa45cddf44f2474a7c"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  def install
    cmake_args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DUA_ENABLE_DISCOVERY=ON
      -DUA_ENABLE_HISTORIZING=ON
      -DUA_ENABLE_JSON_ENCODING=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <open62541/client_config_default.h>
      #include <assert.h>

      int main(void) {
        UA_Client *client = UA_Client_new();
        assert(client != NULL);
        return 0;
      }
    EOS
    system ENV.cc, "./test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lopen62541"
    system "./test"
  end
end
