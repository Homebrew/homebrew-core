class Librdkafka < Formula
  desc "The Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/v0.9.4.tar.gz"
  sha256 "5007ad20a6753f709803e72c5f2c09483dcbce0f16b94b17cf677fb3e6045907"
  revision 1

  head "https://github.com/edenhill/librdkafka.git"

  bottle do
    cellar :any
    sha256 "e84ae423378088e3b43bcd17b963840ac0c6098a7873e9b127b7bc2ef0adc5d0" => :sierra
    sha256 "43ce4e704faaacc8205a167171e8a21d1c2d7aba0bae51a869c5d415a49ce17f" => :el_capitan
    sha256 "a9d7f46bc7ceb26e9d0b321e708f3d4b6314d46b84f2f609c9e923d3db84b7f6" => :yosemite
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
