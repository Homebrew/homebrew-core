class Netcode < Formula
  desc "Secure client/server protocol for multiplayer games built on top of UDP"
  homepage "https://github.com/mas-bandwidth/netcode"
  url "https://github.com/mas-bandwidth/netcode/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "4728716200aa3c4d64f57c2fa063ae036e8538a798ca7d60471ec8eddb682d50"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e31e32ce446a4ecd7173f02e538883b613e9c645ae1dc41784b91cb6625f88f6"
    sha256 cellar: :any, arm64_sequoia: "f32b9ab2ce12bb27c45164e519b50ae759a3e0db973c5e9580fd16a1328fe57d"
    sha256 cellar: :any, arm64_sonoma:  "6398421964c365d1cd333ac5a3ba697015d401a729b9f2604d256dee7c3879d0"
    sha256 cellar: :any, sonoma:        "c04d8b450e3d33acdd4817ad0f9bec325cc6ab8eae3e923f2738671efe1e0d4f"
    sha256 cellar: :any, arm64_linux:   "95bfff7fe6115f7afa047118f9a45ad3f00bebedb24e7ff13a10db3a81e5cc2f"
    sha256 cellar: :any, x86_64_linux:  "9239824ef384d3fd1ddf97132b1c554e44c632ef6d7f21773202299bac5e1423"
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
