class LibpahoMqtt < Formula
  desc "Eclipse Paho C client library for MQTT"
  homepage "https://eclipse-paho.github.io/paho.mqtt.c/MQTTClient/html/"
  url "https://github.com/eclipse-paho/paho.mqtt.c/archive/refs/tags/v1.3.14.tar.gz"
  sha256 "7af7d906e60a696a80f1b7c2bd7d6eb164aaad908ff4c40c3332ac2006d07346"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d55229a93fe81c43dcde42d0e91a30560f59706fbcafaf498f89dd7fce239f90"
    sha256 cellar: :any,                 arm64_sonoma:  "863dc484fc7e89fb897247383508a65671150dc19658c77a4d5ae845741ecdcd"
    sha256 cellar: :any,                 arm64_ventura: "157eb3c732c87b9076c20ddf800a2a2f715411a1f740655efc12b62b00d17e33"
    sha256 cellar: :any,                 sonoma:        "58a80e95499276f4aba24dbe00ea4db55488018d3d36a3a20b65f52b6df7e0e1"
    sha256 cellar: :any,                 ventura:       "c21e0cee9e3dfe56df0fad42da8ec929b22bdccbc486ec234413b1af62642864"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec8c25b958082700fff41cbdd68dd824d443563e6836c9e9bde0adbdce4b2817"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "411c4aadc6df1cb439016386644145a4f2bd412282dda6b3ab4b52b111632f54"
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
