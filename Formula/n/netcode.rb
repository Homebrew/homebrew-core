class Netcode < Formula
  desc "Secure client/server protocol for multiplayer games built on top of UDP"
  homepage "https://github.com/mas-bandwidth/netcode"
  url "https://github.com/mas-bandwidth/netcode/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "3618a3acef21831b9d5e59278c4f6c0cfdc8235984db8d9a30683f853bec3fe4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7b6c13d6520871e13cb3fdbcc0dfa0762bece0cd55cd619ba4d74a4361d2a903"
    sha256 cellar: :any, arm64_sequoia: "7cdf8e38663f23d751bcba8d798ad23c8c9749c49ee5f18a1fea09eb83471481"
    sha256 cellar: :any, arm64_sonoma:  "be11bac4a4a85ea6131350f48eb71b75157b2868983f891cda4d7ee021298369"
    sha256 cellar: :any, sonoma:        "a8bc71cb3b64b3197649354000c022225457001382d2a727b311d4bd8a956aa3"
    sha256 cellar: :any, arm64_linux:   "3ce767ab0aa9cbe21848b92a7c33853042a55afa7a3f2474d353789213a3b7a1"
    sha256 cellar: :any, x86_64_linux:  "9a0406adcf4eeec6ccae322973e097f06c22f256bea7481fdb33b8828ff14e12"
  end

  depends_on "cmake" => :build
  depends_on "libsodium"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DNETCODE_SYSTEM_SODIUM=ON",
                    "-DBUILD_SHARED_LIBS=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <netcode.h>

      int main(void) {
        if (netcode_init() != NETCODE_OK) return 1;
        struct netcode_address_t address;
        if (netcode_parse_address("127.0.0.1:40000", &address) != NETCODE_OK) return 1;
        if (address.port != 40000) return 1;
        struct netcode_server_config_t config;
        netcode_default_server_config(&config);
        struct netcode_server_t *server = netcode_server_create("127.0.0.1:40000", &config, 0.0);
        if (!server) return 1;
        netcode_server_start(server, 16);
        if (!netcode_server_running(server)) return 1;
        netcode_server_destroy(server);
        netcode_term();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lnetcode", "-o", "test"
    system "./test"
  end
end
