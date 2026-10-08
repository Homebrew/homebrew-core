class Librdkafka < Formula
  desc "Apache Kafka C/C++ library"
  homepage "https://github.com/confluentinc/librdkafka"
  url "https://github.com/confluentinc/librdkafka/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "e6b61de61d3282879a88e4ee3d9f634a8b05bf78a9198dfc25c4820c0c9ed231"
  license "BSD-2-Clause"
  revision 1
  compatibility_version 1
  head "https://github.com/confluentinc/librdkafka.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "65f514461395d96e732205fb23a549dd030c264f1f55de9eedbf1ed7b24d4259"
    sha256 cellar: :any, arm64_tahoe:       "6158cd4b04a7034da5543eca3004eb64610f4094c7a9ffcc74ce561e40b7b739"
    sha256 cellar: :any, arm64_sequoia:     "40adcbed915d53f85e575aceb2e43f2723835a5706de6bed51f068c930486cfc"
    sha256 cellar: :any, arm64_linux:       "06943c2cd73806fac8c4b57df8edbcd6294d9debda5418f69e3e86b0e987455c"
    sha256 cellar: :any, x86_64_linux:      "24514b2b9fe83f99a0f6ab052c0c0ecc3c47b65a6c9c0d5fc3268b695f7f3504"
  end

  depends_on "pkgconf" => :build
  depends_on "lz4"
  depends_on "lzlib"
  depends_on "openssl@4"
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "cyrus-sasl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <librdkafka/rdkafka.h>

      int main (int argc, char **argv)
      {
        int partition = RD_KAFKA_PARTITION_UA; /* random */
        int version = rd_kafka_version();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lrdkafka", "-lz", "-lpthread", "-o", "test"
    system "./test"
  end
end
