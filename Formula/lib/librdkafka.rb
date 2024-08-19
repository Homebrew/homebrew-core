class Librdkafka < Formula
  desc "Apache Kafka C/C++ library"
  homepage "https://github.com/confluentinc/librdkafka"
  url "https://github.com/confluentinc/librdkafka/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "3dc62de731fd516dfb1032861d9a580d4d0b5b0856beb0f185d06df8e6c26259"
  license "BSD-2-Clause"
  head "https://github.com/confluentinc/librdkafka.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a8fe68b05e077d9fcc4b56dfce0464b2de12945b4f1456ca18613640c1d15846"
    sha256 cellar: :any,                 arm64_ventura:  "98b46b50c48c052a562d621c39f9dfa07fa9780bde0de32470499dc5e4ffe6a1"
    sha256 cellar: :any,                 arm64_monterey: "6103608170fa619a4ad6aa4276dc889c86140ef0bc78019f4197ce8019da26dc"
    sha256 cellar: :any,                 sonoma:         "2423f0e26db407d1bc02ed4022b6a2e6aadf2567b866e28f46231127a0684dce"
    sha256 cellar: :any,                 ventura:        "a2c7322e256621f5722c2a6f8e1b9bc300916d3bf29fb717a3c035a3cec0b9f7"
    sha256 cellar: :any,                 monterey:       "8d76e1d2e176f7900fdc4d762a7d9392d71b67188fa555c82a55d2da64e1eec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f765cf7002aaacbba352b14147904383fcddeefe599648edd73afe0f8fee4bb"
  end

  depends_on "pkg-config" => :build
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
