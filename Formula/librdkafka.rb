class Librdkafka < Formula
  desc "The Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/v1.3.0.tar.gz"
  sha256 "465cab533ebc5b9ca8d97c90ab69e0093460665ebaf38623209cf343653c76d2"
  head "https://github.com/edenhill/librdkafka.git"

  bottle do
    cellar :any
    sha256 "a2ed4daef1757720cdcffea3fd51271f86c4dc59fbc834c51c365c011547da09" => :catalina
    sha256 "503d1848ef0909e467233aeffb55653ba594f05ab262306692fce45d4d9eafa8" => :mojave
    sha256 "c8d90277c835b532fe08bbf40f451709b643f471654bdb5b53fe4a4075f69707" => :high_sierra
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
