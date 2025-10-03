class Libjuice < Formula
  desc "UDP Interactive Connectivity Establishment (ICE) library"
  homepage "https://github.com/paullouisageneau/libjuice"
  url "https://github.com/paullouisageneau/libjuice/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "5078176d55042f3ccf3999c2556d84903f7edf80177ce4a7bf59507541e93938"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8cccd369e20fbd7e6617824b2c1c6c13edb0b673d8f2226879815cf779c9ed3b"
    sha256 cellar: :any,                 arm64_sequoia: "6c8bb25c5f68da436317f1b8232ca01ec2e52ef08d3dcd1bf0b0c15021fe4a01"
    sha256 cellar: :any,                 arm64_sonoma:  "0750b5a64f7fc9ff2e636220749d8d531c352890bb8d9d27ec113ab2246bbd15"
    sha256 cellar: :any,                 sonoma:        "50b9962df18835ea6e19ba827619c5dbedf5fdc97c6fa401c57c716e8a149a82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a27428dfd81b02c3b3f673a7d15f308a6628c835aa1d1012fbc967582a40a07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5b1029cab3becc363fc941b753c74de42bdc4ac164c5d4eeff5edca42f089d2"
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
