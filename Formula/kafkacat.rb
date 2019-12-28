class Kafkacat < Formula
  desc "Generic command-line non-JVM Apache Kafka producer and consumer"
  homepage "https://github.com/edenhill/kafkacat"
  url "https://github.com/edenhill/kafkacat.git",
      :tag      => "1.5.0",
      :revision => "3b4bcf00d322533c374e226f2a4eb16501e8a441"

  bottle do
    cellar :any
    rebuild 1
    sha256 "9036ee74f10f3fdc433ea892f07edffcd4b128e472cd5a11750f346f769656c1" => :catalina
    sha256 "e52935dccf7a4cc05ae01254944de5ffe6da7ea64dfbe824e6d4d17f9195a283" => :mojave
    sha256 "9355dd65392055feebb5cb820b296804ea53629d2230cd48ec17f24027c7c096" => :high_sierra
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
