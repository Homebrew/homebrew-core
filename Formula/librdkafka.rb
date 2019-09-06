class Librdkafka < Formula
  desc "The Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/v1.1.0.tar.gz"
  sha256 "123b47404c16bcde194b4bd1221c21fdce832ad12912bd8074f88f64b2b86f2b"
  head "https://github.com/edenhill/librdkafka.git"

  bottle do
    cellar :any
    sha256 "70d894cd4ec83c789df7697c333134dd4282d60a236b4fdc82dedf986860bb42" => :mojave
    sha256 "b4ef9db2570d96ccb2f7f78e1d5086370cc002b9834ad42d9c9b126ffcde3d7e" => :high_sierra
    sha256 "74aa62a9ae1e4193c7f12d732b0ecce9f636f0e6af80bfa8dd97e63ab9a934a7" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "lz4"
  depends_on "lzlib"
  depends_on "openssl"
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
