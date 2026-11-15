class Libjuice < Formula
  desc "UDP Interactive Connectivity Establishment (ICE) library"
  homepage "https://github.com/paullouisageneau/libjuice"
  url "https://github.com/paullouisageneau/libjuice/archive/refs/tags/v1.7.4.tar.gz"
  sha256 "95c088862aa1b88b73d62aa99577135010eb768fcafb252d13aa85a8515ef798"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "bead0107e9de47a3a962a72371bd5a9e5b69f309f918e284d651a3780c7bf4fd"
    sha256 cellar: :any, arm64_tahoe:       "c8db775e80fddda39991c0ac872b620ce79c427ed899594df23cc07a7a1e3baf"
    sha256 cellar: :any, arm64_sequoia:     "618428cd60b8ea4782ce0deee98e71c7da97ab3a9f1ce53c54db9ad60c26597b"
    sha256 cellar: :any, arm64_linux:       "c2bcd8293c0195034e627ccc6cca9c235fd5c23dfcb1a0d070b4ad27ae91bbb8"
    sha256 cellar: :any, x86_64_linux:      "daa1e89bbb463b3f2195a9d5c180223529b95105513d1d4d7838aa37197e2854"
  end

  depends_on "cmake" => :build

  deny_network_access!
  def install
    system "cmake", "-S", ".", "-B", "build", "-DNO_TESTS=1", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <string.h>
      #include "juice/juice.h"

      int main() {
          juice_config_t config;
          memset(&config, 0, sizeof(config));

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
          if (agent == NULL)
              return 1;
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
