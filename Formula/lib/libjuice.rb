class Libjuice < Formula
  desc "UDP Interactive Connectivity Establishment (ICE) library"
  homepage "https://github.com/paullouisageneau/libjuice"
  url "https://github.com/paullouisageneau/libjuice/archive/refs/tags/v1.5.4.tar.gz"
  sha256 "2bf66694978f9d5724836f40c56de35abd9175efebc249989afb1ae5164627c0"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "b08257650332d43260be1259b0d58059c5e44e87c1b979b2c6b2814803b5530a"
    sha256 cellar: :any,                 arm64_sonoma:   "c4baf951246303a05489af779141a392bc73bb7367a797ea55d25b8985407d4c"
    sha256 cellar: :any,                 arm64_ventura:  "60827692b3af2454638fc7e260e70d98af9daccb22025aa27a42472555455aa9"
    sha256 cellar: :any,                 arm64_monterey: "80ae3adc26da632e7c91392a7f19f087c7830e27c5926a50b3cf12c61cdde46b"
    sha256 cellar: :any,                 sonoma:         "78e686b01678518284628aa604e66fb888dd3f427f217d243ed214469915d4da"
    sha256 cellar: :any,                 ventura:        "2ccff0c9b83d556a9a44be5d3112e1010cd35250a089091a67fed69ef4051387"
    sha256 cellar: :any,                 monterey:       "b1a637537144ca068e4ed4316aea39b6d280b4609585986f02be04e34830cb71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d56eb49f04ac061a63f4d8b9e9a6cecacc1af9bf7f31dc1de4091e99ebe44a90"
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
