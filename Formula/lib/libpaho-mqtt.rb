class LibpahoMqtt < Formula
  desc "Eclipse Paho C client library for MQTT"
  homepage "https://eclipse.github.io/paho.mqtt.c/"
  url "https://github.com/eclipse/paho.mqtt.c/archive/refs/tags/v1.3.12.tar.gz"
  sha256 "6a70a664ed3bbcc1eafdc45a5dc11f3ad70c9bac12a54c2f8cef15c0e7d0a93b"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1b1949c46f45c38beac0417ebc1d81c431a5ed725ca620eea6cfdc8a0c03990e"
    sha256 cellar: :any,                 arm64_monterey: "617f7bd6f68f83473ffdb893623600f8206d8db03df74e8797ece00861de2d64"
    sha256 cellar: :any,                 arm64_big_sur:  "b7fe29b30b2e02016aa06329badbd7953a80abe9c974c26658b1fb8b9b35ad6d"
    sha256 cellar: :any,                 ventura:        "f9ecee90f911fc2f3209ac17130f214e583e32a0a87268b485cc2ee5acfb174b"
    sha256 cellar: :any,                 monterey:       "67f3cdaf51cb4c730facc65931f8245bb253bf560f8a444d83dfcbe976532973"
    sha256 cellar: :any,                 big_sur:        "fa05a2643fe2956e4a838777f34df44f8ef72d096438229c9d6c49351c2e9c9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ea31b35020c2ce8c4a3257ee8a36fbe873649f1ee8d421d5eadd22c992e9702"
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
