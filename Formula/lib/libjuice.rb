class Libjuice < Formula
  desc "UDP Interactive Connectivity Establishment (ICE) library"
  homepage "https://github.com/paullouisageneau/libjuice"
  url "https://github.com/paullouisageneau/libjuice/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "9b145cbf4c88829249b33cf6d8d92f575694d557d1b36e780b6903c10f7094b8"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7ba26ae15b490051eebb820493f305b32c6d2407538e01255fdfe33bed441f66"
    sha256 cellar: :any,                 arm64_ventura:  "c74831bd0d7656207ec842be2188f8cb8c546ed9f3cef3dd1ac56ca1de1fc200"
    sha256 cellar: :any,                 arm64_monterey: "22007fcb8cb60bbc94248bec446df0bff34c153fcbb8415c9d90c5c5c8a8492f"
    sha256 cellar: :any,                 sonoma:         "d9d28db37b0a414131ebd38ffbafadc7ee6054e31a8c3ceedf8d9d4534a8ae72"
    sha256 cellar: :any,                 ventura:        "77507fa82ad005ee75f30d013aa46ff6bc8dbe60ed4d5ff0481e9bfbeb7affc5"
    sha256 cellar: :any,                 monterey:       "401e6c121b824e0828afe67ae4025586c42c176faaaee5bfccb9d8ddc890ddb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bd036220c275574ba900b2b43f6c7f333572016afce04266aaf4a2ddbcde7d9"
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
