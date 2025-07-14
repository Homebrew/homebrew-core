class Librdkafka < Formula
  desc "Apache Kafka C/C++ library"
  homepage "https://github.com/confluentinc/librdkafka"
  url "https://github.com/confluentinc/librdkafka/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "592a823dc7c09ad4ded1bc8f700da6d4e0c88ffaf267815c6f25e7450b9395ca"
  license "BSD-2-Clause"
  head "https://github.com/confluentinc/librdkafka.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2ac3aa0a91ea976d3727697d001e443b338688951d2b6a2d25aac7cd90aff251"
    sha256 cellar: :any,                 arm64_sonoma:  "2526867da6b0c75f1158b9362f3ff6e398773065f190bb55b9f498c67ddb9e8e"
    sha256 cellar: :any,                 arm64_ventura: "6836ce187b58c920a72c5ad986880d0bc15e1e43815c2c77431a8030d058b05d"
    sha256 cellar: :any,                 sonoma:        "1f240fc839e22fa052d6bd8eec9e63669868f3490134c2e9c059bbf2b84ad517"
    sha256 cellar: :any,                 ventura:       "0f58b52753588fdaa2c116a3c744154fc96171f20870657dd6745c8500a41ca0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e6d9d4c008ebb2e2f6204f8b0b0b0fc776dd83381946c522f8d5b1814965df8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e29667cd155192a052ac1fd82b11e094d1ef91e96b3c09a8342df869d7b56dc0"
  end

  depends_on "pkgconf" => :build
  depends_on "lz4"
  depends_on "lzlib"
  depends_on "openssl@3"
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "cyrus-sasl"
  uses_from_macos "zlib"

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
