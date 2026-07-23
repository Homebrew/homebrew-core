class Open62541 < Formula
  desc "Open source implementation of OPC UA"
  homepage "https://open62541.org/"
  url "https://github.com/open62541/open62541/archive/refs/tags/v1.5.5.tar.gz"
  sha256 "a5f3d15eab72afb2ed67838b71f0d2c4c09b880d003857f71fc17b7279f2d397"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a52e09e90dedaee661f626a26d2c6c4f20e7b2502fe42715c9d545526fac35d0"
    sha256 cellar: :any, arm64_sequoia: "1c718aada1292d5259c65ecba118ff710ebe9ba0204d459e00625dbf993b7f61"
    sha256 cellar: :any, arm64_sonoma:  "442cf9b5b9af214276aded81c4c30e1ac48770a2a090983af701b3be97559145"
    sha256 cellar: :any, sonoma:        "d6f87f3269b4c66573969424836ba660e90226035a3d05f613ef218aa6bd2447"
    sha256 cellar: :any, arm64_linux:   "34b1023c450acd6a0f0b75698d0c7c8e3b57cd5057794220f0d001f6abc4ff70"
    sha256 cellar: :any, x86_64_linux:  "a34c64f7a77d750dfe58d8cf14b5827157ca87ad4080c76fc501899f5e591557"
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
    (testpath/"test.c").write <<~C
      #include <open62541/client_config_default.h>
      #include <assert.h>

      int main(void) {
        UA_Client *client = UA_Client_new();
        assert(client != NULL);
        return 0;
      }
    C
    system ENV.cc, "./test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lopen62541"
    system "./test"
  end
end
