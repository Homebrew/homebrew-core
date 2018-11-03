class Librdkafka < Formula
  desc "The Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/v0.11.6.tar.gz"
  sha256 "9c0afb8b53779d968225edf1e79da48a162895ad557900f75e7978f65e642032"
  head "https://github.com/edenhill/librdkafka.git"

  bottle do
    cellar :any
    sha256 "ff7dc8fd37b6a998330c63744e0a4f65568eb08154c8752786bc9fb113777926" => :mojave
    sha256 "9ac390ab143923e3cdc3cece266fab5d24cbe1f65f5f6865b706252abee4c6bb" => :high_sierra
    sha256 "7da3cc5dc1ba920c43a80ef36d635284dbdb03d74f83fbd8ed6a77d0d3200c51" => :sierra
    sha256 "ce900fd3577e37b7d2ed4a92c1ce09af84e5f6e11080cf324157a27e2aed755e" => :el_capitan
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
