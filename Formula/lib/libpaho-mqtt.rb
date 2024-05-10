class LibpahoMqtt < Formula
  desc "Eclipse Paho C client library for MQTT"
  homepage "https://eclipse.github.io/paho.mqtt.c/"
  url "https://github.com/eclipse/paho.mqtt.c/archive/refs/tags/v1.3.13.tar.gz"
  sha256 "47c77e95609812da82feee30db435c3b7c720d4fd3147d466ead126e657b6d9c"
  license "EPL-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4c81ade278b4fc5b5ae9d673b1b767eda05122076cf31630536fd2a39b6fd1a0"
    sha256 cellar: :any,                 arm64_ventura:  "39dc0450eb42667c233984346e8a66f03725aae6e19489613c6409add367abeb"
    sha256 cellar: :any,                 arm64_monterey: "5207a2f947557bd0ebd6c8a19fc4d4a2e625bc72c5c66ed0791f7e4daa19389c"
    sha256 cellar: :any,                 sonoma:         "f58295eb27253495ba78600498b0734cc7c8747769a925c7cf142b29bad9fb85"
    sha256 cellar: :any,                 ventura:        "fe739bcc8ca3076716cba9c62bc03426e7db1f5904d2a16395f3c33477032b58"
    sha256 cellar: :any,                 monterey:       "2d1d8d4daf0519aeb6b87264a5e5922b2ad434eb489a40c355ad7392a7f3be7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dd9e5c251de73ad1e46a6c3acacd32e0492a6deb20b93f98d9fcf1ab847fc0a"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", "-DPAHO_WITH_SSL=ON", *std_cmake_args
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
