class Libjuice < Formula
  desc "UDP Interactive Connectivity Establishment (ICE) library"
  homepage "https://github.com/paullouisageneau/libjuice"
  url "https://github.com/paullouisageneau/libjuice/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "298c7a3ba4f325b901b0a9cfd84fcb8b85bcfec5989ac5816102f356d0683b4f"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "01ed4702f5ec4bab0d56c918bbd09a22887433c1b12dacc3f2d42db4067e508f"
    sha256 cellar: :any,                 arm64_ventura:  "dd4559d204479b9e0734bbdb6412ae8d695df5ed6d7a01acb56651f04e09a292"
    sha256 cellar: :any,                 arm64_monterey: "94588a139e4ba8a74dd944b9345a22c3f1910d66a8a746331c4a80a12cf18312"
    sha256 cellar: :any,                 sonoma:         "caecaaf88a8ef0f1d43ae4748a9beb36250e3c87828a9e66311f8b45a2764ced"
    sha256 cellar: :any,                 ventura:        "d58b324b155ab6192774f42f50c046585c3c5e83e7eefb7c1c88d28a7be379a4"
    sha256 cellar: :any,                 monterey:       "7828dd8f9660967a8ac9d2b60e291de6b63c7634fc173ededce0462326cace96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33bd94540dd2b656af7e4a6d0004d55046e1c09bf3648cce94dc7841f70d559a"
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
