class Libjuice < Formula
  desc "UDP Interactive Connectivity Establishment (ICE) library"
  homepage "https://github.com/paullouisageneau/libjuice"
  url "https://github.com/paullouisageneau/libjuice/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "c127629ff42b9fffc06c65e94abb25fce03856160ce05d9fdfdad4ed80ea59bf"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f0c4ada30a7a5f6c40e127717f73065cafe0101a48c29e17a1fa2fc153a5b553"
    sha256 cellar: :any,                 arm64_sequoia: "92df2f8bc781ac438d0fb5ddf3272a4cab8a6f18693b0109ea8ca7e3b59799da"
    sha256 cellar: :any,                 arm64_sonoma:  "c6ba8d8ee44f437fc2f72dd334ce71c9cc78da810a80a9da2579d38424672832"
    sha256 cellar: :any,                 sonoma:        "f56a3083118cbfb2d5ea0142c9c97d138a31557315c425e02baaa4e3b0d50ac1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15dcaf69c44907e619539411e435db7d41a637790e55f9ef552e34f70330ccf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c25f4dd19b15fd84dc5974445ce8a60fe9870737f11aa3118dd7c14a6af7107"
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
