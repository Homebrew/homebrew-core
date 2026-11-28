class Libjuice < Formula
  desc "UDP Interactive Connectivity Establishment (ICE) library"
  homepage "https://github.com/paullouisageneau/libjuice"
  url "https://github.com/paullouisageneau/libjuice/archive/refs/tags/v1.7.5.tar.gz"
  sha256 "a0cdc9069613d4dfdc54f829ad11ebd23fedf345bc43727fbcd2f5439f2425bd"
  license "MPL-2.0"

  bottle do
    manifest_sha256 "0b2880bf7140f5c63e2ad83ecbd6a375231d6a1f78ec37983e98bf15fcb6fffa"
    sha256 cellar: :any, arm64_golden_gate: "0a1a7e5114406e3603ea73e41b1b05dcee3b3875ad7a1f989233056eb6ecaeb0"
    sha256 cellar: :any, arm64_tahoe:       "1ee6c66a8d8560e92f23c828b448450df1b7de0e086674a1440ae9ac32ae30c4"
    sha256 cellar: :any, arm64_sequoia:     "ad09c7d79021247bc4bc95d37f3cad4bef99c43fd3e8668125363cf2e94c3497"
    sha256 cellar: :any, arm64_linux:       "a624c6e6ecb40cf928172035de7c8434514cf89a88e4a90674e075d811af061c"
    sha256 cellar: :any, x86_64_linux:      "263d39cfcf0ab415079f7df02c7a410183b2d741c2ef9f4b3510f1e569f3b03e"
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
