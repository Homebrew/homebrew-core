class Libjuice < Formula
  desc "UDP Interactive Connectivity Establishment (ICE) library"
  homepage "https://github.com/paullouisageneau/libjuice"
  url "https://github.com/paullouisageneau/libjuice/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "245c705c153c1c8da2d79b288a09e1801420b582df1d70498dcab67fc392bd3a"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1d8b504b3f5cf0537d84f2ba9054e9e789e81caf4e3656cc6d2b1aeb01260fe1"
    sha256 cellar: :any,                 arm64_ventura:  "203855285c99295224b2b302df8d94e04489d9fd3e3463d90ac2ee3d68250d7c"
    sha256 cellar: :any,                 arm64_monterey: "99b2bc38051b5337554f4d8148704ec5496391487326ce66f8cfc30ab25cbe75"
    sha256 cellar: :any,                 sonoma:         "fad54d41dadb62f55af7feb3f53fd36d9f5d6328f42263ffb9da36ba1da3f218"
    sha256 cellar: :any,                 ventura:        "b6d55618c2d2ab23a016deeeb1c97324909431cfc2179c414a1fb55a8af587bb"
    sha256 cellar: :any,                 monterey:       "87554c3c32f2a3868d284f8a4eb4b10865a6e087967d8d0742661a4516df453c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac8dffc347b5035b3c86d2c26e116bfeda082fe2f87c553f032862a45b3abdac"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DNO_TESTS=1", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ljuice", "-o", "test"
    system "./test"
  end
end
