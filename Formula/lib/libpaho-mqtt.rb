class LibpahoMqtt < Formula
  desc "Eclipse Paho C client library for MQTT"
  homepage "https://eclipse-paho.github.io/paho.mqtt.c/MQTTClient/html/"
  url "https://github.com/eclipse-paho/paho.mqtt.c/archive/refs/tags/v1.3.16.tar.gz"
  sha256 "8b960f51edc7e03507637d987882bc486d8f4be6e79431bf99e2763344fd14c5"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "16433282b65e480ba201c3d7be20a04f9a467df60ca0dd8656759edbb3be7b58"
    sha256 cellar: :any,                 arm64_sequoia: "b96324bc57c2bdb2e2dde3b4179f240c9474dad0e0421f33a32c845cba22c4af"
    sha256 cellar: :any,                 arm64_sonoma:  "2aa9e33c14b99b5ab12843a7ff761d09a2fb21053727c8278648f4c5ac8ffb8b"
    sha256 cellar: :any,                 sonoma:        "93be86edbcb744aca1ba39596adf2a4f0e461dfb8be17f273d8e342306278770"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edfda6f2d2cbc26452874c4f12234ca9e188f7be4e8c4052447463b5e5ea7a96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f742ea550c8656fa6e967dd1a444acce319272b57e42649f54781508b3fa398"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", "-DPAHO_WITH_SSL=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>
      #include <MQTTClient.h>

      int main(int argc, char* argv[]) {
          MQTTClient client;
          MQTTClient_connectOptions conn_opts = MQTTClient_connectOptions_initializer;

          return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lpaho-mqtt3a", "-o", "test"
    system "./test"
  end
end
