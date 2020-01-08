class Kafkacat < Formula
  desc "Generic command-line non-JVM Apache Kafka producer and consumer"
  homepage "https://github.com/edenhill/kafkacat"
  url "https://github.com/edenhill/kafkacat.git",
      :tag      => "1.5.0",
      :revision => "3b4bcf00d322533c374e226f2a4eb16501e8a441"

  bottle do
    cellar :any
    rebuild 2
    sha256 "af4674858fa32d4c39346018f441609647f35071ef9d7615f214ad47594e1b6f" => :catalina
    sha256 "169186d382345c58af1a3a616493ce305f7abb808420ac95a8230e9bcbcec2d9" => :mojave
    sha256 "60bca6aa0aae36980bcd917cb0ff1b042d7cb3317c5e6e6446488c25ac1edf29" => :high_sierra
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
