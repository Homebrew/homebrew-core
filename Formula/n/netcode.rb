class Netcode < Formula
  desc "Secure client/server protocol for multiplayer games built on top of UDP"
  homepage "https://github.com/mas-bandwidth/netcode"
  url "https://github.com/mas-bandwidth/netcode/archive/refs/tags/v1.4.8.tar.gz"
  sha256 "a92b6a86bfc746409684510aec46b4beef63efd9e4734999d415debe48311753"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6e01068c5cd40225d9550012afd02753347befa0be1621538b9f047d3288b082"
    sha256 cellar: :any, arm64_tahoe:       "90c7a90dfe4163d0f157ad840e6130ebf8bf2f461724ca4fa69ae46afdedbbc9"
    sha256 cellar: :any, arm64_sequoia:     "bc06d84ad658409a81e3266d46ac699e97bfb066de77c299530c47a476428966"
    sha256 cellar: :any, arm64_linux:       "33716f51b8b4be6fce3555d705b113cf575a2705bbdefda5ebf7a8dd65da94fd"
    sha256 cellar: :any, x86_64_linux:      "6ab54f635c99f63cf06ff4e05862b5a8325a6e1d903cf3dbe5fc587035a39180"
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
