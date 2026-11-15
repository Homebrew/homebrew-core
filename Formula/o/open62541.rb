class Open62541 < Formula
  desc "Open source implementation of OPC UA"
  homepage "https://open62541.org/"
  url "https://github.com/open62541/open62541/archive/refs/tags/v1.5.10.tar.gz"
  sha256 "b05e47734e2e39c0b00511ed6dc22e71f1b5bf7864b86280653a5128d171c0ed"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a7e488894024291fbeb7b237c20880de221fa16e83cf97e0f34d040033319506"
    sha256 cellar: :any, arm64_tahoe:       "e4cb43a2125bcf5042b26595a3ab7f5ef6e271b3cd86d55b2a56cd3400c04e64"
    sha256 cellar: :any, arm64_sequoia:     "48d7223a4739e083d61d23ca8435415ca4fcab2a0502c2af40c1405c478e5625"
    sha256 cellar: :any, arm64_linux:       "a63d66b00b2e6fcd5c8f986359a2b4ad6ed01ee425c5f43dbb2eb029cdc151eb"
    sha256 cellar: :any, x86_64_linux:      "e72117e6c3093a40797436a8a60581c2e85e40fdc2d2ffbb6bc619eb9ba62538"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  deny_network_access!

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
