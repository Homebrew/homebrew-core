class Librdkafka < Formula
  desc "The Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/v0.11.3.tar.gz"
  sha256 "2b96d7ed71470b0d0027bd9f0b6eb8fb68ed979f8092611c148771eb01abb72c"
  head "https://github.com/edenhill/librdkafka.git"

  bottle do
    cellar :any
    sha256 "dce656349af51404992cc1d56911f9339adaf45074675bcc1d8e48b8230006c2" => :high_sierra
    sha256 "772484a79bccead9e8964c572a0cb6a35432fdd3979f3f2f876f608db3d1d96f" => :sierra
    sha256 "444a966aeed17701a3ee4d7d1087aef507695600144bcf7e0ff747c0f9d662b8" => :el_capitan
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
