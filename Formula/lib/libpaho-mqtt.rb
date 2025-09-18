class LibpahoMqtt < Formula
  desc "Eclipse Paho C client library for MQTT"
  homepage "https://eclipse-paho.github.io/paho.mqtt.c/MQTTClient/html/"
  url "https://github.com/eclipse-paho/paho.mqtt.c/archive/refs/tags/v1.3.15.tar.gz"
  sha256 "60ce2cfdc146fcb81c621cb8b45874d2eb1d4693105d048f60e31b8f3468be90"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "301d603ff946f350a2f8848a4bb21b94c52bf15b635c04be9ab5c163aa9ab1fc"
    sha256 cellar: :any,                 arm64_sequoia: "25f1526acb75aafdb1683ec76af1fd090f28dd20d768fac47a237750dffba2ff"
    sha256 cellar: :any,                 arm64_sonoma:  "d6fa44e3412e34e1cc816c765f88bc8e67cdbd890d6333db3e086a1e2119e2ae"
    sha256 cellar: :any,                 arm64_ventura: "647a8fa2a445366592e13dac591fe43b68e201258ab9a70bf363afabd09f6052"
    sha256 cellar: :any,                 sonoma:        "1ddaf0f68b03cc24301019f417d22afffca599d021255b27214dfa790a07f925"
    sha256 cellar: :any,                 ventura:       "a45411db7ed423d58d23a90dda2f152bef568d869dcfb80a1c5a6eac249f6d7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b3b51057342e302d15ac08dbe235e5c008c3a98f7d27c114d2c7eb326f2cb8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b2abc8010ccfff54bad2bf246217ae54dce4b22f486927ba4b5c4b8583bbe16"
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
