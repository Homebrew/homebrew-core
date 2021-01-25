class Librdkafka < Formula
  desc "Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/v1.5.3.tar.gz"
  sha256 "2105ca01fef5beca10c9f010bc50342b15d5ce6b73b2489b012e6d09a008b7bf"
  license "BSD-2-Clause"
  head "https://github.com/edenhill/librdkafka.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 "b2e4bc434128ae0051500313fb75f584590edcc52801727c3a7a56667377100e" => :big_sur
    sha256 "a18360feef0dce0cbb1b4aa519c91c78040f0b1ff30d1f1aea7fa1c362f98d4a" => :arm64_big_sur
    sha256 "694b593d8b0c3a3e36b3583c59d5df46096839b7efe94144498bf2e784b438c5" => :catalina
    sha256 "7c9b9a039460637f5271309113080485e5b32a75c7b28f0669441e52e6b1bab7" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
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
