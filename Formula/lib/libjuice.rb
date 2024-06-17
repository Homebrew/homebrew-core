class Libjuice < Formula
  desc "UDP Interactive Connectivity Establishment (ICE) library"
  homepage "https://github.com/paullouisageneau/libjuice"
  url "https://github.com/paullouisageneau/libjuice/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "39b9d54440b82cd78c8448cb9687c2fa43b4cdb0e629f8981d73ce2ad63350bf"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4bd4ca23472949dea0ef436370f12ec7fcfdb8d60b30980ebca34e43e0d12dfe"
    sha256 cellar: :any,                 arm64_ventura:  "abff935658a807c2acacaa5179b5cd11b533315ae6fb45707c23ccef54b9c1cb"
    sha256 cellar: :any,                 arm64_monterey: "44a4921010935abbb0edeee3f2ffe92f725c272993549df530ea303b081cf926"
    sha256 cellar: :any,                 sonoma:         "45eddcbc035567fef87f8781b24700b17ccea241f8bc9b97965c8f7f6aea9913"
    sha256 cellar: :any,                 ventura:        "11c209a12bdfe1167da640c5d2e88344ad333301579d6de6e23610be1b0b8601"
    sha256 cellar: :any,                 monterey:       "5a60ca59447e0eaf27cd4451698e021f08e45890fd558c336dda3344787dbc09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0c95931044be39d947c1255fa08cd91d5a3571b92470b228f63bf0080a2269e"
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
