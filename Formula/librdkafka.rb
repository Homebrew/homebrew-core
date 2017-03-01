class Librdkafka < Formula
  desc "The Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/v0.9.4.tar.gz"
  sha256 "5007ad20a6753f709803e72c5f2c09483dcbce0f16b94b17cf677fb3e6045907"

  head "https://github.com/edenhill/librdkafka.git"

  bottle do
    cellar :any
    sha256 "24fa8334f54dff2cca4dfec93352550de92ee0f38ab4fc04c9fdf69c5968af59" => :sierra
    sha256 "79253c4ca04908ec37e171c191138ebbe9dc7376971b0de29d57599b13d84e74" => :el_capitan
    sha256 "1d42f6ff44c79b0a94475e6f5c216a63c8edffc4fd779b106ba7c1ad1dd45a96" => :yosemite
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
