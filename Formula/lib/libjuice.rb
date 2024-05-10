class Libjuice < Formula
  desc "UDP Interactive Connectivity Establishment (ICE) library"
  homepage "https://github.com/paullouisageneau/libjuice"
  url "https://github.com/paullouisageneau/libjuice/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "4e49ea49e614cc3fe9e972a68fd79d236a3ad3940e28143cf6d811e64ffc9143"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e8a34a7ab95045b47623f8453a442bb44d950bd218e517d7d33e5feca41c6a68"
    sha256 cellar: :any,                 arm64_ventura:  "0940c921c8071a1733534f3c4f870fd82d33bc5091eadf94259d30923c698e0c"
    sha256 cellar: :any,                 arm64_monterey: "399ca7b4bf4e8702b9a223fe7e55a5edef99a8a7c839e1319e7ab2ef023273b6"
    sha256 cellar: :any,                 sonoma:         "2d4edb54f7f1af6210601df87dbab0c402b597d93b00ba97197e69160c27a392"
    sha256 cellar: :any,                 ventura:        "747c962dbf37580bdc05516f265bc03e1b03352e43b9d757e55db9b45db378d4"
    sha256 cellar: :any,                 monterey:       "fa4a0a6449c04af4abcba3c336fe6ef03f9f154ad8f51c5cea7f43c16400421e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ba05a26c60293253f4a4eb8d78e4af788ed4f26807aab0ad99438ece79d380b"
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
