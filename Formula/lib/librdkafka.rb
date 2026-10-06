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
    sha256 cellar: :any, arm64_golden_gate: "3e64820fd1e75723825b4134102329faf8a93688fb16cb851a16e9c21109cdef"
    sha256 cellar: :any, arm64_tahoe:       "f0a4fcf1f1088cc99403cbcbf5d400d3ddcd990e56489867637becc88efc29e0"
    sha256 cellar: :any, arm64_sequoia:     "ebb4812dca0663471306b27ac01113c39a4a09bc3a2ef0d1f8ce81592c64c083"
    sha256 cellar: :any, arm64_linux:       "a57e3cc3e14a0f3a0cb911127da3c31d8194da3ab6ed4ef93ddfab59ff5a91fc"
    sha256 cellar: :any, x86_64_linux:      "552e31352ddc5bbc4e8770f58e40acb3108fa4446030eb659bee810e0d4be607"
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
