class Librdkafka < Formula
  desc "The Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/v0.11.0.tar.gz"
  sha256 "d4baf9a0d08767128913bb4e39d68995a95d7efa834fcf3e4f60c3156003b887"
  head "https://github.com/edenhill/librdkafka.git"

  bottle do
    cellar :any
    sha256 "71c8c1129d979b71e0f913123fcee18de35f9cfff8e8ebe4b9853715f12fb883" => :sierra
    sha256 "7da8d9887c86f7d89661e626499162b465c28ff14661903cf77a74026bfa9024" => :el_capitan
    sha256 "154a6c61b2ad9f0ace15cc8265cda3ed718296af399f7b68b5783da0cc96b316" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "lzlib"
  depends_on "openssl"
  depends_on "lz4" => :recommended

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
