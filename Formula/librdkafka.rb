class Librdkafka < Formula
  desc "The Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/v1.0.1.tar.gz"
  sha256 "b2a2defa77c0ef8c508739022a197886e0644bd7bf6179de1b68bdffb02b3550"
  head "https://github.com/edenhill/librdkafka.git"

  bottle do
    cellar :any
    sha256 "e6a42a6afe3d2e7921d27db8660ddd6dcca87c90f3bec34cc6729d200981a067" => :mojave
    sha256 "46270e25287e4f901ecc63c91f619274d234ec6b0688c1693d07ec349693067e" => :high_sierra
    sha256 "57756ff780de0a27a00959205288c8172dca6aad1e59cdb6b62174db31b6c038" => :sierra
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
