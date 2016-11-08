class Librdkafka < Formula
  desc "The Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/v0.9.2.tar.gz"
  sha256 "e4fcde677b8cbb6076070a3fbf54ef5f5b495879a2d2e78af8601f2544ee84ae"

  head "https://github.com/edenhill/librdkafka.git"

  bottle do
    cellar :any
    sha256 "40bc4c4295471e4c9209c28d5b1b3485717e5e310c5fb297e86558853a5178aa" => :sierra
    sha256 "dd1b9001bfd24f6cdc942fbe6c1b52e992e1e65ff1849962b2528fc8cd5773d5" => :el_capitan
    sha256 "e516c7b35fb951370b102a73ef89f07fc40884c8f92e4c449c59a6933c32d148" => :yosemite
    sha256 "a002a4f38bc21030d9c5a69dec3de560ec67ce5e976f80cbcb7cd52fbdfb22f3" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "lzlib"
  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <librdkafka/rdkafka.h>

      int main (int argc, char **argv)
      {
        int partition = RD_KAFKA_PARTITION_UA; /* random */
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lrdkafka", "-lz", "-lpthread", "-o", "test"
    system "./test"
  end
end
