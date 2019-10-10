class Librdkafka < Formula
  desc "The Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/v1.2.1.tar.gz"
  sha256 "f6be27772babfdacbbf2e4c5432ea46c57ef5b7d82e52a81b885e7b804781fd6"
  head "https://github.com/edenhill/librdkafka.git"

  bottle do
    cellar :any
    sha256 "b250dd98bf323cd44c51cb6c0c662a459fb37c5d4c4f0e50390765e96867492a" => :catalina
    sha256 "4a998c5569421cbfba8f17c857f3b56d4f141380e86b01d76cd3e9194826e6dc" => :mojave
    sha256 "d3b92b192f7f6e47149afea2afde0aa80a6e1f9a85481fb5e8847172fa08aa14" => :high_sierra
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
