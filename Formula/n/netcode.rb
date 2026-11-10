class Netcode < Formula
  desc "Secure client/server protocol for multiplayer games built on top of UDP"
  homepage "https://github.com/mas-bandwidth/netcode"
  url "https://github.com/mas-bandwidth/netcode/archive/refs/tags/v1.4.10.tar.gz"
  sha256 "8f08f610f6360ade97b3de00032eda36ecebeccf02405fdf60fde3ee67e2d524"
  license "BSD-3-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5bd5199c2645b18bd8baa3bbc6fe35da3ebedfdec2d0269d2ffc4d61151cf632"
    sha256 cellar: :any, arm64_tahoe:       "49c78dd045d551df4b53d37122cd65c0b98274d276b62b1ecb6bc7e646da8c37"
    sha256 cellar: :any, arm64_sequoia:     "24d0ce692e834e7840b059a644f8241cae209abb1b38ddf43a213fe96b1fce8c"
    sha256 cellar: :any, arm64_linux:       "926a3ce6ce9762e38667aa2cdb26f6981a03793c24bf41d1337f38da69ee6700"
    sha256 cellar: :any, x86_64_linux:      "00584a9bcd008628834719c0cd522c37ad277824f240f365a4d556bce079cb87"
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
