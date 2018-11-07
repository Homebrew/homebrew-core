class Librdkafka < Formula
  desc "The Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/v0.11.6.tar.gz"
  sha256 "9c0afb8b53779d968225edf1e79da48a162895ad557900f75e7978f65e642032"
  head "https://github.com/edenhill/librdkafka.git"

  bottle do
    cellar :any
    sha256 "fdee6d4f1e1c766f30376ae615897e914a2156813301d109a808110d2fec48aa" => :mojave
    sha256 "010faca3301dc9b642c4e014b8872d3d6566764a247233922b9c4d2b84cb5765" => :high_sierra
    sha256 "59cfb8b1c265af8a81156928bd8e3f562e2be178f83702a1d390bfe0e2782144" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "lz4"
  depends_on "lzlib"
  depends_on "openssl"

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
