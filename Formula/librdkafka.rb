class Librdkafka < Formula
  desc "The Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/0.9.0.tar.gz"
  sha256 "e7d0d5bbaed8c6b163bdcc74274b7c1608b4d8a06522c4fed1856986aee0a71a"

  bottle do
    cellar :any
    sha256 "63b97ce272e07632f10e33a7963f291bf1a0457f0823d4ab4bdce01eb3e65bbe" => :el_capitan
    sha256 "ffa2e218bbd43230c3a999b3adb7f4e08f132a15fa43ae552dd7692874834f91" => :yosemite
    sha256 "bc601cb49f68155fd4a6f6ef67c5030fb59766d0c86701a284419a4256f640f8" => :mavericks
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
