class Librdkafka < Formula
  desc "The Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/v0.11.5.tar.gz"
  sha256 "cc6ebbcd0a826eec1b8ce1f625ffe71b53ef3290f8192b6cae38412a958f4fd3"
  head "https://github.com/edenhill/librdkafka.git"

  bottle do
    cellar :any
    sha256 "852978d934a2ec27765cdf6bd9b0b26ecff7051620ac54e66163c42f59a04783" => :high_sierra
    sha256 "2684881f72662f7957dd793f8cb2191b62d04e0022c74bd41a3df234cff67688" => :sierra
    sha256 "5f2ecf9a88ebd7b39cf2965359d9609545148d5cae2581fc6887b713968a951d" => :el_capitan
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
