class Libjuice < Formula
  desc "UDP Interactive Connectivity Establishment (ICE) library"
  homepage "https://github.com/paullouisageneau/libjuice"
  url "https://github.com/paullouisageneau/libjuice/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "90a13ed7049b97af4dcb494e5a82ebbffc41d29f917d17f0aa1b0b651034ae4c"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6bd090a24a94428cab57fb034e1455e0619c65d5a0a97985f90368b843be5598"
    sha256 cellar: :any,                 arm64_sonoma:  "e7d063977b60306b38c406e11535fcfbdcb27dfb61e1bb3e9867ab98c98a4ee0"
    sha256 cellar: :any,                 arm64_ventura: "efd9bbb6690c378921d744548057133dfe173fadddc71f68a989aa0df623c5f9"
    sha256 cellar: :any,                 sonoma:        "99406c20337f6c8e4047378c776ab4746215fe62cc1c88f39ff05a8122f1acf4"
    sha256 cellar: :any,                 ventura:       "19a281b7db9b022432d1b17d162de31527dcf4add8a24590f3b8e958bd4a4b6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f408f03e6fb479d4a327f71c585fd6aaea1ae52b5217b8c4b42cb2e27014d0c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eea94f4f7ffe75d7dfe4fc8fabf02996f92a2db2cb2debd5d32d60a23ad6d32e"
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
