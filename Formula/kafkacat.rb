class Kafkacat < Formula
  desc "Generic command-line non-JVM Apache Kafka producer and consumer"
  homepage "https://github.com/edenhill/kafkacat"
  url "https://github.com/edenhill/kafkacat.git",
      :tag      => "1.5.0",
      :revision => "3b4bcf00d322533c374e226f2a4eb16501e8a441"

  bottle do
    cellar :any
    sha256 "93f09459a4a835dc4506c78ffd2a22f28a357f1dc359f1083c1a68b6c59e914b" => :mojave
    sha256 "1a22bb79786c31a5c58114b79571171f339b901529e302c3d99311b385075d2a" => :high_sierra
    sha256 "f087b771ff8f6a7de9fa412980b4449139b1130bf1dd8fc0d58380bfcc334551" => :sierra
  end

  depends_on "librdkafka"
  depends_on "yajl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-json"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"kafkacat", "-X", "list"
  end
end
