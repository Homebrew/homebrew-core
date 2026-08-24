class Libjuice < Formula
  desc "UDP Interactive Connectivity Establishment (ICE) library"
  homepage "https://github.com/paullouisageneau/libjuice"
  url "https://github.com/paullouisageneau/libjuice/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "86e075ca4732882746b6d5733ff1b6090f942e5750df58630b191b5f00f30010"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9b280cf11c72a8ce83c81a533ae779c6cb695b680c50d5ffc3e9161bf3a44980"
    sha256 cellar: :any, arm64_sequoia: "40a5b2578b1edfdae54968907408884612bfbaeeb4cde04158a66baf2fa42064"
    sha256 cellar: :any, arm64_sonoma:  "aacc7afc57205c401eb2299c1bc90af9d8fca31277cc59f9b9a42a07efb05ae4"
    sha256 cellar: :any, sonoma:        "954b4eb41b90d6138b0e0a3bb4956165397e87a8e688735c85bc1ddc32efdaf7"
    sha256 cellar: :any, arm64_linux:   "adbea2a9be0c30c1cbf88fb8fd5dca22f49eaa31c6fd2c929b088c61c1a2dd30"
    sha256 cellar: :any, x86_64_linux:  "a20cd988fa3b04410e7907c4e437dfbdc851bc4cc46e4c7d8a0c4ba446ee8471"
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
