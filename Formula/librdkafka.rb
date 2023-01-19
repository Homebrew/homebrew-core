class Librdkafka < Formula
  desc "Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "3670f8d522e77f79f9d09a22387297ab58d1156b22de12ef96e58b7d57fca139"
  license "BSD-2-Clause"
  head "https://github.com/edenhill/librdkafka.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f33a78efa7d09c74c4131141e52fd89e8dba03c8a32890fb97def0256d50e2a2"
    sha256 cellar: :any,                 arm64_monterey: "3dfc263e227ee5cdf77fce17aee09dcecb5f4329fd6ae4d0192fa14fc33314a3"
    sha256 cellar: :any,                 arm64_big_sur:  "f4f4a32bb5bfe9a32f1494c7fe10843efc2099de4e1600f21a4ab3f7d0ff7be9"
    sha256                               ventura:        "377eb97a5fee85c482d4fed279240428424efefd7979887f4e2b287df8ec5230"
    sha256                               monterey:       "ff85877c23d5995cc81498c831199b81e6a54a8d163b990fcfed80e3a4b09061"
    sha256                               big_sur:        "aa520fc13eb604bde603ed082985a6187d2af8292f4e852bebccf685ff2ef1b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9893416e871563d6f084c408b72ffd3a7baa29591f6f230808282b185b4032d"
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
