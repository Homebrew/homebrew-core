class Librdkafka < Formula
  desc "The Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/v1.1.0.tar.gz"
  sha256 "123b47404c16bcde194b4bd1221c21fdce832ad12912bd8074f88f64b2b86f2b"
  head "https://github.com/edenhill/librdkafka.git"

  bottle do
    cellar :any
    sha256 "05de92dfb559b5725a42750985dc66607b360d4a5b6e1e5348b5596382869c93" => :mojave
    sha256 "4a5148ffb55d3589cfa2adbe3618e1f6dc84c90a3f6f7232b3b8f5a07d421b10" => :high_sierra
    sha256 "fbe38875e0693531d820bba8be5ca9d40bf17488b45e165a23b7b2b4333869bd" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "lz4"
  depends_on "lzlib"
  depends_on "openssl"
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
