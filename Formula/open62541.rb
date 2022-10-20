class Open62541 < Formula
  desc "Open source implementation of OPC UA"
  homepage "https://open62541.org/"
  url "https://github.com/open62541/open62541/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "52c049c0f107b4cc382c9e480d677a6360cdd96c472f84689af91b423bd108cb"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3b90f3197319fc805c95e69a4d799bf1f2f55e9196659e31616be7daae5925e0"
    sha256 cellar: :any,                 arm64_big_sur:  "87413da0058cdb3979d7615ce2e4c05b5099c5a3a8885eaf720bb8e35d1bac70"
    sha256 cellar: :any,                 monterey:       "4b7c16700c7bebd1b82661c65de8ac7339c77923b0b8f67bdb0c081eaf98dbd1"
    sha256 cellar: :any,                 big_sur:        "3e1da93619f98eca294d208a10e8efa6a8b4b892edc9d3b58c672e35c9bf5384"
    sha256 cellar: :any,                 catalina:       "fc998f5e579a05c37b4c5657339aae3ee1ff0405f17fa847d72a8881679e9e3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39d0747e1d15e9bbb3b14da2e9cb2c1cbfb42ab86f3fb6cb830491922654e77b"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

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
