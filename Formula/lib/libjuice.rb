class Libjuice < Formula
  desc "UDP Interactive Connectivity Establishment (ICE) library"
  homepage "https://github.com/paullouisageneau/libjuice"
  url "https://github.com/paullouisageneau/libjuice/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "75159867c4a5a689a6559e11aa0d30c9eba12ce73a4ae3d898b521467e1f635d"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f1e78cce2eb6ea006d4ff28b2323925581e538bfb82c93d34d587251cc9c90e4"
    sha256 cellar: :any,                 arm64_sequoia: "b3f2ee1f575519fdc97872b7e82766480415c197a0fb4c5e5cb5781321a5fa3d"
    sha256 cellar: :any,                 arm64_sonoma:  "b3b1b90e4695d5ac6186f905e6a26c0cb14c4e3e8519f10f1f82048793e19dbb"
    sha256 cellar: :any,                 sonoma:        "8953e08c9c6db27015a810656b8db66b1082f185daf47d6d4c69716968b24159"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8259600a2ebb565ec5eee65dad1024857fed43ae0f52deb14ad603a603008a79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "260c2f1c012b30ef8ebd14ccf3fd83ddcf67ca420976f230900cb5477c7dc1d4"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DNO_TESTS=1", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include "juice/juice.h"

      int main() {
          juice_config_t config;

          config.stun_server_host = "stun.l.google.com";
          config.stun_server_port = 19302;
          config.turn_servers = NULL;
          config.turn_servers_count = 0;
          config.user_ptr = NULL;
          config.cb_state_changed = NULL;
          config.cb_candidate = NULL;
          config.cb_gathering_done = NULL;
          config.cb_recv = NULL;

          juice_agent_t *agent = juice_create(&config);
          printf("Successfully created a juice agent\\n");

          juice_destroy(agent);
          printf("Successfully destroyed the juice agent\\n");

          return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ljuice", "-o", "test"
    system "./test"
  end
end
