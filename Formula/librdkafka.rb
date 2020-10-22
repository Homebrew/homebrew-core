class Librdkafka < Formula
  desc "Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/v1.5.2.tar.gz"
  sha256 "ca3db90d04ef81ca791e55e9eed67e004b547b7adedf11df6c24ac377d4840c6"
  license "BSD-2-Clause"
  head "https://github.com/edenhill/librdkafka.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 "cf3cf9c7b0d6a66b77897d5b922311e040a6b3c08d3cbf44592685d279299ddf" => :catalina
    sha256 "b1928bcbd897a110b5924d0d181050488e923b85fad328100d7748baf065708b" => :mojave
    sha256 "685a700c58c4e7b46275640f02e7f2c9c722b8c50e441554c5d7e1d6e67405a0" => :high_sierra
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
