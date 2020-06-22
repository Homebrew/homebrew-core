class Librdkafka < Formula
  desc "The Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/v1.4.4.tar.gz"
  sha256 "0984ffbe17b9e04599fb9eceb16cfa189f525a042bef02474cd1bbfe1ea68416"
  head "https://github.com/edenhill/librdkafka.git"

  bottle do
    sha256 "aeb65f3ab7698df3558d34f6d7b48afd74443038bcfb88241ca0859d7094061a" => :catalina
    sha256 "0016c630e88d215dbca89598f95c86ab9cafb4b697164c41f52c122f4ec4000c" => :mojave
    sha256 "31d79c743190d68310911756175d7dc9637c5cad567519f84021ca8349583cf8" => :high_sierra
  end

  depends_on "pkg-config" => :build
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
