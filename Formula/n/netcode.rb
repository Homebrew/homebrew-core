class Netcode < Formula
  desc "Secure client/server protocol for multiplayer games built on top of UDP"
  homepage "https://github.com/mas-bandwidth/netcode"
  url "https://github.com/mas-bandwidth/netcode/archive/refs/tags/v1.4.5.tar.gz"
  sha256 "ac967ae1dcf97ca7e38a873a0c1ee28412d476e3040900ff1244749f7385c2b5"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a4e3a853c4be4223a8acfca62720003635a5a29cdc81097de6f4c9202cdc882d"
    sha256 cellar: :any, arm64_sequoia: "b7949db15ccdd82d6bafed71f9af53aa64ed30bd67681ac0036b5a569e15daa0"
    sha256 cellar: :any, arm64_sonoma:  "da603a352f7c11efea96a98567402936bdf2b43bb25e2684a63c87b110d7e799"
    sha256 cellar: :any, arm64_linux:   "c72940c57ed7ca7fa02d8a2df2235aa09297585c0fc0afa67bdbb43dbfb3d6e8"
    sha256 cellar: :any, x86_64_linux:  "e3243bfd5c38aea83eb6d9c0073f8da8bf8e3bda99ee8a1264730510573e27b6"
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
