class Libjuice < Formula
  desc "UDP Interactive Connectivity Establishment (ICE) library"
  homepage "https://github.com/paullouisageneau/libjuice"
  url "https://github.com/paullouisageneau/libjuice/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "a510c7df90d82731d1d5e32e32205d3370ec2e62d6230ffe7b19b0f3c1acabf2"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f162c7efec28783d18424f4296e36b45e7667b5c43e24e0d97c25e19a778be47"
    sha256 cellar: :any,                 arm64_sequoia: "2d4865498294cda53d0067ddeb046f6b13633361bdf2d52a6e0e8905caf093ea"
    sha256 cellar: :any,                 arm64_sonoma:  "a6fa24cb3a899d13b5c0afd778f5cc4c6ffc9fcb990fb0cdd517ac77326ede86"
    sha256 cellar: :any,                 sonoma:        "06ea06b5c2ab9114d52e10a3337ec7bde5effd4e4c6474e959f99e8ec22e4d34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4684874fd3b1e6e7129fbd01e7182fb60f10fe04ed6f022027d7ce09578fed4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b22030b7b092dc674ef23d92693d528acd4595c93cdfad83828f935380cad72b"
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
