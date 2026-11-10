class Netcode < Formula
  desc "Secure client/server protocol for multiplayer games built on top of UDP"
  homepage "https://github.com/mas-bandwidth/netcode"
  url "https://github.com/mas-bandwidth/netcode/archive/refs/tags/v1.4.10.tar.gz"
  sha256 "8f08f610f6360ade97b3de00032eda36ecebeccf02405fdf60fde3ee67e2d524"
  license "BSD-3-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9bfa65147fd6721dee2814b72493793118dfb95cc87c4d165fee8e963cde89c9"
    sha256 cellar: :any, arm64_tahoe:       "47cc0a736b38fd986fdbb2c7d66812fc71f81db96cc27d7dd31fa99c03833e23"
    sha256 cellar: :any, arm64_sequoia:     "4cc65d3c85dc7b881e5a076828af436cf78b54bab4c656909db2b198de756bcd"
    sha256 cellar: :any, arm64_linux:       "966a97a99766d3c3b9b2e21db21465960542b0323db1b68c6623af6fca81f183"
    sha256 cellar: :any, x86_64_linux:      "621e779b090e1c1e5f2933fe455f2fe5c4670ff7b9791e22e7a48439624474f0"
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
