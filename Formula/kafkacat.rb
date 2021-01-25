class Kafkacat < Formula
  desc "Generic command-line non-JVM Apache Kafka producer and consumer"
  homepage "https://github.com/edenhill/kafkacat"
  url "https://github.com/edenhill/kafkacat.git",
      tag:      "1.6.0",
      revision: "3cd845bf782296b3e8eb382020173782281746d2"
  license "BSD-2-Clause"

  bottle do
    cellar :any
    sha256 "7be256a4f0a2a853b80fd5ded94cd397034e36ec2df13e106d7c766ede8ca4fb" => :big_sur
    sha256 "e57ada6783bdc01f55704d0f166d9fb90634bb1036dbdd7f9197097696a35990" => :arm64_big_sur
    sha256 "b24a6909714b2d35a1255dd938964ebf200b6f6107c8b385596eb94c7111bddd" => :catalina
    sha256 "37db83112a083daec2d6d91c50e256ca899d43de19e8cd9e58f31a4cf630cab5" => :mojave
    sha256 "12e0795c76f11c17bfd32f3d59c16ce81025084b925a1ed0cb4e676fc5be76b3" => :high_sierra
  end

  depends_on "avro-c"
  depends_on "librdkafka"
  depends_on "libserdes"
  depends_on "yajl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-json",
                          "--enable-avro"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"kafkacat", "-X", "list"
  end
end
