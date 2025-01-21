class Libjuice < Formula
  desc "UDP Interactive Connectivity Establishment (ICE) library"
  homepage "https://github.com/paullouisageneau/libjuice"
  url "https://github.com/paullouisageneau/libjuice/archive/refs/tags/v1.5.8.tar.gz"
  sha256 "aa81809384c7e2594853304034a60fa2c2a234483b31cb531a4fc19e5877b709"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8114b2c5a914d996effce7772f21b6d877fde292385c17ea62db47a8c0d308f4"
    sha256 cellar: :any,                 arm64_sonoma:  "b6a4709f7aea8838211237dc2e0a561db4d931ac642718b72391efcf4e4dcaeb"
    sha256 cellar: :any,                 arm64_ventura: "d73d5053024c25199a307d80a3d60a5f57338c502c7c5dcf35353d5acc0b8235"
    sha256 cellar: :any,                 sonoma:        "e97537138f8c0b300f751a89c0b3a5db6abf14f973729540b48f428d316a1450"
    sha256 cellar: :any,                 ventura:       "e79c1bff0f581fdfbfd218b2bf062fbceba38394a6553e1666e13428f93d7a83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ed8a17683c7ec4440464d6da3c0b394125a67e8ee1a0f3ca4fc369cc720961b"
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
