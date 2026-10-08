class LibpahoMqtt < Formula
  desc "Eclipse Paho C client library for MQTT"
  homepage "https://eclipse-paho.github.io/paho.mqtt.c/MQTTClient/html/"
  url "https://github.com/eclipse-paho/paho.mqtt.c/archive/refs/tags/v1.3.16.tar.gz"
  sha256 "8b960f51edc7e03507637d987882bc486d8f4be6e79431bf99e2763344fd14c5"
  license "EPL-2.0"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "07546812ea899bd199fa038cfbf8c25135b66e222f9abe11435e4f9c3d82c629"
    sha256 cellar: :any, arm64_tahoe:       "a6696485cf5500d5304600d65498656d5c6a4850f1389585fe2f616a636bbee9"
    sha256 cellar: :any, arm64_sequoia:     "5a298cd63176a48ce31d8db4f7d37e9e56e1501c09a41135a85fa98528388c32"
    sha256 cellar: :any, arm64_linux:       "73b47ca633318eb9c1a2e2901c05a7e6182929fbfb5df97f8b500d3869287dc7"
    sha256 cellar: :any, x86_64_linux:      "23659c2201dacad6ecd74c5b12a4c5fdc7f59f0db4ba78b4d92a9e18cc0c5479"
  end

  depends_on "cmake" => :build
  depends_on "openssl@4"

  deny_network_access!

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DPAHO_WITH_SSL=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
