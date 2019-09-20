class Librdkafka < Formula
  desc "The Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/v1.2.0.tar.gz"
  sha256 "eedde1c96104e4ac2d22a4230e34f35dd60d53976ae2563e3dd7c27190a96859"
  head "https://github.com/edenhill/librdkafka.git"

  bottle do
    cellar :any
    sha256 "094ffea67a23f1005396cc714e245e6a81e97fcbe5b53b5d0a3016370cfbe6a2" => :mojave
    sha256 "69752ecf88756de2f69b4c394892601bd9b0fc786a122d7b09a5c1ac0c4830f9" => :high_sierra
    sha256 "1a84e92592eb2914e8ed18fe328f0b1d54a4c448419a67a9eaeaadfd1957e600" => :sierra
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
