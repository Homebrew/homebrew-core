class Librdkafka < Formula
  desc "The Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/v1.2.0.tar.gz"
  sha256 "eedde1c96104e4ac2d22a4230e34f35dd60d53976ae2563e3dd7c27190a96859"
  head "https://github.com/edenhill/librdkafka.git"

  bottle do
    cellar :any
    sha256 "d9054304a3d34f8d19123111b8c06fe4a08b98880ad7d91a73be3117816f75e5" => :mojave
    sha256 "aaffaa86f082a49b2f09ab62ff46480416ca6da5976fe34585642ad80b94a0d2" => :high_sierra
    sha256 "a5c4c7ff0d046cd794fc99c2b5d1ccca3576090ebf61e5c47279007c8e1a1178" => :sierra
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
