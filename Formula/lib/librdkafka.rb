class Librdkafka < Formula
  desc "Apache Kafka C/C++ library"
  homepage "https://github.com/confluentinc/librdkafka"
  url "https://github.com/confluentinc/librdkafka/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "259015220cdca708afe838b5aa79ebf1a5fb710fb4179cf918d390aed85d5dbc"
  license "BSD-2-Clause"
  compatibility_version 1
  head "https://github.com/confluentinc/librdkafka.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9958141ffa7f7719590d7cd9a8cddf04e26df07190f6ed6dd8002b656fb2cdac"
    sha256 cellar: :any, arm64_sequoia: "dac88b03054e299b1cfdd7f9385c2ebf1f2f8977f1a881929af8e66514347256"
    sha256 cellar: :any, arm64_sonoma:  "0e5ae213f72d187a328b2f96d1071e94cb041f5679a6692c947c8fd16cac0bb7"
    sha256 cellar: :any, sonoma:        "3a64d05ec9c2f8a96d1dab18bb70a560319063b8fce6579f08d268ea251c071b"
    sha256 cellar: :any, arm64_linux:   "8b2af8fd4cecc48355fd6f08e5829ae7a346cb3eae7a00e608096dcea96a66a7"
    sha256 cellar: :any, x86_64_linux:  "bbbd46aab8045526b53dfc0b4d272b1dce6f7f51beada19bdc950791f8804256"
  end

  depends_on "pkgconf" => :build
  depends_on "lz4"
  depends_on "lzlib"
  depends_on "openssl@3"
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
