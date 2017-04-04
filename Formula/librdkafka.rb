class Librdkafka < Formula
  desc "The Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/v0.9.4.tar.gz"
  sha256 "5007ad20a6753f709803e72c5f2c09483dcbce0f16b94b17cf677fb3e6045907"
  revision 1

  head "https://github.com/edenhill/librdkafka.git"

  bottle do
    cellar :any
    sha256 "3f89621392055facce588981b67bfa294817112bcc0a16cdc09e174502f986b9" => :sierra
    sha256 "ec2833fbcf5003c0e566122523b34347509743eb2f3e81989866fcaf9b17087f" => :el_capitan
    sha256 "0d4340247793dd7fae4c573d1b30ab8c500d13e6684c23540b1b8d563d7ce46b" => :yosemite
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
