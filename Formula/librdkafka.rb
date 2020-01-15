class Librdkafka < Formula
  desc "The Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/v1.3.0.tar.gz"
  sha256 "465cab533ebc5b9ca8d97c90ab69e0093460665ebaf38623209cf343653c76d2"
  head "https://github.com/edenhill/librdkafka.git"

  bottle do
    cellar :any
    sha256 "b1eb668f9a0f2baf248a94f2c0b88e0fe8ce4f07745a18fd1ca7d99324b777fa" => :catalina
    sha256 "f2be2e15d096671088a0bd76429ad651c008aea18c7acf7828abda9d2c925ec5" => :mojave
    sha256 "0c437ace1c068e76c25e849c659b420c9a2c59fd27d1ec6f935f190f40b4672d" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "lz4"
  depends_on "lzlib"
  depends_on "openssl@1.1"
  depends_on "zstd"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <librdkafka/rdkafka.h>

      int main (int argc, char **argv)
      {
        int partition = RD_KAFKA_PARTITION_UA; /* random */
        int version = rd_kafka_version();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lrdkafka", "-lz", "-lpthread", "-o", "test"
    system "./test"
  end
end
