class Librdkafka < Formula
  desc "The Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/v0.9.2.tar.gz"
  sha256 "e4fcde677b8cbb6076070a3fbf54ef5f5b495879a2d2e78af8601f2544ee84ae"

  head "https://github.com/edenhill/librdkafka.git"

  bottle do
    cellar :any
    sha256 "033d6b22393921e086b3e96c321019994fff84c9d34ed8e6033d09d26406d0a0" => :sierra
    sha256 "06052eff546aaf4b36a951913a231f606a921082bd94a0bfd2383197df25f1f7" => :el_capitan
    sha256 "2f50d32d16bcde11957d514c8fb276df92e5c7a6ebe196c052aa9b61df602ec4" => :yosemite
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
