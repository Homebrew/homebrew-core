class Librdkafka < Formula
  desc "The Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/v0.11.0.tar.gz"
  sha256 "d4baf9a0d08767128913bb4e39d68995a95d7efa834fcf3e4f60c3156003b887"
  head "https://github.com/edenhill/librdkafka.git"

  bottle do
    cellar :any
    sha256 "1b7a69d683e7be5a1e4a6e5f42dc5c6617e49096b268da64702e4c48a170965f" => :sierra
    sha256 "281b700a2311ccc79dc50bcb53f78f49842c1200b8ce37acd3e456004cf73ddc" => :el_capitan
    sha256 "26217b88fa07fe43f9b33a6cafd8dfb87c990210fa38efd5a33d2ba1af135fa0" => :yosemite
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
