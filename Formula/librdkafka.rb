class Librdkafka < Formula
  desc "Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "93b12f554fa1c8393ce49ab52812a5f63e264d9af6a50fd6e6c318c481838b7f"
  license "BSD-2-Clause"
  head "https://github.com/edenhill/librdkafka.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "7699e0c5c5fa9468030abdfe81e6f359e748fde2226ce72cef666990b96ed390"
    sha256                               big_sur:       "24514c561488b0a0ddbb2a86293ed18b9a3a28d200a442c09d393df039e10d5f"
    sha256                               catalina:      "e0131515c1197694e11241e8ae5bb264fc1ed77d28963c6cd9ded892c9e12c54"
    sha256                               mojave:        "672ed2b535d7de9eb7a7fd7a21621cc265e3ed2fdc890a46b12ae0133ea45fd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee39317000a4923c6ae4afa644feb0450b2afb02bfa752253dd921ebfd71cd37"
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
