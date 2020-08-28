class Librdkafka < Formula
  desc "The Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/v1.5.0.tar.gz"
  sha256 "f7fee59fdbf1286ec23ef0b35b2dfb41031c8727c90ced6435b8cf576f23a656"
  license "BSD-2-Clause"
  head "https://github.com/edenhill/librdkafka.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 "de52443a4f2739cdf63dda80c8baf58bca86a5d836ceea9704d009b7977a3ee4" => :catalina
    sha256 "00ab941019a34002e2face071b15810aa224b26c1d0322cb02768eb6b937ad42" => :mojave
    sha256 "80617f9dd06dd50e6c103b4bdbff40957ecae1755c85d7b6cb395b411bb37e2f" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.8" => :build
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
