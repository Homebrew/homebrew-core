class Netcode < Formula
  desc "Secure client/server protocol for multiplayer games built on top of UDP"
  homepage "https://github.com/mas-bandwidth/netcode"
  url "https://github.com/mas-bandwidth/netcode/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "77399eff996ffd43f8c7bf496d7b51aa6dfc76a57055812505ef7610e554a1c5"
  license "BSD-3-Clause"
  compatibility_version 1

  bottle do
    manifest_sha256 "6fffef07c8485710912dc84958e317736b3d88e98b9106bc690b4dd56f6c3ffe"
    sha256 cellar: :any, arm64_golden_gate: "79a55986f366f73712edad24e28999a23d99dbfcd7485505e62f0a5969538565"
    sha256 cellar: :any, arm64_tahoe:       "6aac5a6fb2d82a766333112f1559d3c6c5b494eedd1d4a1ae508e22ba3b2b6d6"
    sha256 cellar: :any, arm64_sequoia:     "358b025a51f9ca0af276c4172c144fa6767978b6c6f89c2b96a75e64d3fa4b87"
    sha256 cellar: :any, arm64_linux:       "a8e65da8418e0095056c8beb570e3a1b88a4069cd41a9c74dbe166391553dec9"
    sha256 cellar: :any, x86_64_linux:      "52e5525e73bc330c34c755492331dd8031642475bbde56ca8d8183a73a385287"
  end

  depends_on "cmake" => :build
  depends_on "libsodium"

  allow_network_access! :test

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
