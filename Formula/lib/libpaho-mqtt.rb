class LibpahoMqtt < Formula
  desc "Eclipse Paho C client library for MQTT"
  homepage "https://eclipse-paho.github.io/paho.mqtt.c/MQTTClient/html/"
  url "https://github.com/eclipse-paho/paho.mqtt.c/archive/refs/tags/v1.3.16.tar.gz"
  sha256 "8b960f51edc7e03507637d987882bc486d8f4be6e79431bf99e2763344fd14c5"
  license "EPL-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "eeeb71c665576f02cc774b84e777eddda3969b2e63ccae7f66f7c5dc1638f999"
    sha256 cellar: :any,                 arm64_sequoia: "c0a8cb599d043492514a8412746d4b281215aa5aeda8db1fd12954a40237b138"
    sha256 cellar: :any,                 arm64_sonoma:  "4320aa4be856759a55293101979436f7a79382d8528b3e8b935068ab5edf0886"
    sha256 cellar: :any,                 sonoma:        "8a3054d689f09b17faa7392f37ecd140fe2e0358b18b472db84f74f7c7556c50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f091e548e02bf60eee30c26f4451aeda7fa77a3f54452349cc98f5568404aed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71be99abeb74ab2fada683b2b0fcae74c3ec65c062d3b273ac033697f08342e5"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

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
