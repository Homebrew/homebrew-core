class Librdkafka < Formula
  desc "Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "f321bcb1e015a34114c83cf1aa7b99ee260236aab096b85c003170c90a47ca9d"
  license "BSD-2-Clause"
  head "https://github.com/edenhill/librdkafka.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3ce1c8e85e204b3cc63b93f94edc8b21e6e10206fcb692d86b4a2682d8555c2e"
    sha256 cellar: :any,                 arm64_monterey: "e5d9a345ac1bcfa80a115bff5282e575fe1cfc84c57cb0a4d4c25526e3cee58e"
    sha256 cellar: :any,                 arm64_big_sur:  "77af759116f9d1b4073da1c3c663d332f58fc2b8879b6241ab4ecaeac18887ce"
    sha256                               ventura:        "cac41aee4a18af7b1b903c9d1ae5ff36cd64b6a3893afceafae5f27db141648d"
    sha256                               monterey:       "5eadf5b572a46e3376a52af5fe6b86e45bc5ca0e8796bd1fdae9ad0f2c8cf43b"
    sha256                               big_sur:        "6c7f1275a487314b87f105a37711338e5d58c530f2f10f729f2a4bfc60ff249b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e69e7a4ba042939430ec43c22e7969de5e3d192fd7104c9407c6c74f23f34449"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "lz4"
  depends_on "lzlib"
  depends_on "openssl@1.1"
  depends_on "zstd"

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
