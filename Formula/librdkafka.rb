class Librdkafka < Formula
  desc "Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/v1.5.3.tar.gz"
  sha256 "2105ca01fef5beca10c9f010bc50342b15d5ce6b73b2489b012e6d09a008b7bf"
  license "BSD-2-Clause"
  head "https://github.com/edenhill/librdkafka.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 "832ed31ebd9fb44415bc5cc6d91edaa094db929c3fe2686589eaee6cf64c88cb" => :big_sur
    sha256 "9aaa1cfe08a116ae3c064062bc2120a98baddc460f956219bac775d8f6ae5209" => :catalina
    sha256 "edc1ad30e18104d2fe4f0e94c457c65231a6c03a7ccddcd71d1486cad86d2816" => :mojave
    sha256 "cd7f63a0dcee584b97bdbf93d56ed0f097c00ec4dc2a1e6dab38368e569118c7" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
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
