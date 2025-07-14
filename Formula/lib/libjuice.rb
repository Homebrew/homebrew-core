class Libjuice < Formula
  desc "UDP Interactive Connectivity Establishment (ICE) library"
  homepage "https://github.com/paullouisageneau/libjuice"
  url "https://github.com/paullouisageneau/libjuice/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "14d7cfc1a541843c1678828ad52d860d043bd82ed39ff076b260565796e4e4ee"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6da0b5a713b960ec13a0d6b7e7d9c23a40d58a81c9e335441ad9196d2ddb7c08"
    sha256 cellar: :any,                 arm64_sonoma:  "f828fccfc20b989be3c87b1571183d05e265b225d61d358e39c386ddf85b11d7"
    sha256 cellar: :any,                 arm64_ventura: "c931b26636ad524503d258d8fc99c4da5e1af8326544540abbe6d8bfda774650"
    sha256 cellar: :any,                 sonoma:        "372b3ee8a5c06a55904af8987b6caacf11f29675818ea892b77a6fe8cb8b0580"
    sha256 cellar: :any,                 ventura:       "70fa825fe8677ab48fdc4b0ee9f3334e7e7743d0c754a85509f6139f279e097e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21f55cd5900b41ca8010b0d9318efd4c398470b7f307477b14bb616448303806"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da1a6722a0b89b733fcc78ba3a961057a0cc26714acacc973ace620dbf73e2e8"
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
