class LibpahoMqtt < Formula
  desc "Eclipse Paho C client library for MQTT"
  homepage "https://eclipse.github.io/paho.mqtt.c/"
  url "https://github.com/eclipse/paho.mqtt.c/archive/refs/tags/v1.3.13.tar.gz"
  sha256 "47c77e95609812da82feee30db435c3b7c720d4fd3147d466ead126e657b6d9c"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "eaad10a2d0f97a601e347085e12cf9572336692cbf4ccef95573111f51e7ccd3"
    sha256 cellar: :any,                 arm64_ventura:  "75bdc2716d718fb0a4f1b6589ac334af3d72117e85a0a752097e8ee8e3e637f9"
    sha256 cellar: :any,                 arm64_monterey: "644685fbe4cbff5008f74fc5542fa7980f7f564c59eedc9ef13adcb6f12016b7"
    sha256 cellar: :any,                 sonoma:         "7d089a4232f1be9061ff010eb1b660a685328bc13c1720c390bb5a24fec40321"
    sha256 cellar: :any,                 ventura:        "741449fe5d789ee28bb74078fad939d61514ee55618ac89dc000fa16a1da3e37"
    sha256 cellar: :any,                 monterey:       "7c809ed5d5f48cfa66d0d3b48c3cd311e9eeff8ede4a794666c7d4082afec217"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c447f230fbd5a5762b9e04baccd4b47303d12bc5cabb8a30cdd9da15fce37a0a"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOT
      #include <stdio.h>
      #include <stdlib.h>
      #include <MQTTClient.h>

      int main(int argc, char* argv[]) {
          MQTTClient client;
          MQTTClient_connectOptions conn_opts = MQTTClient_connectOptions_initializer;

          return 0;
      }
    EOT
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lpaho-mqtt3a", "-o", "test"
    system "./test"
  end
end
