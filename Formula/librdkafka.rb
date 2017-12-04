class Librdkafka < Formula
  desc "The Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/v0.11.3.tar.gz"
  sha256 "2b96d7ed71470b0d0027bd9f0b6eb8fb68ed979f8092611c148771eb01abb72c"
  head "https://github.com/edenhill/librdkafka.git"

  bottle do
    cellar :any
    sha256 "c101376cb494b33f88e26b6d2d009f8c90025cb8bd4607c9dcbb7d155ed05996" => :high_sierra
    sha256 "fdd939c6b199b39cf4762d513efb86ed64052f03cb62bf4997384c5d982c0653" => :sierra
    sha256 "466ef46e22e50663b119354ff67c4a0a0652b63e6106b6ba232d6cb5e79b2318" => :el_capitan
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
    (testpath/"test.c").write <<~EOS
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
