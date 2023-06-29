class Librdkafka < Formula
  desc "Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "7be1fc37ab10ebdc037d5c5a9b35b48931edafffae054b488faaff99e60e0108"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/edenhill/librdkafka.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b48272331da76364ef0750f1e559f91b56bb1f02a5aece39bb515b02f5d53ad0"
    sha256 cellar: :any,                 arm64_monterey: "c26f87eaf145ca4e6a85b6b108206c9fd43b7f63c0be49c49bce437609c3a85b"
    sha256 cellar: :any,                 arm64_big_sur:  "ee2d2edecbfa469ba05b8d5d5a4f6a13c3632ff40676894103f667be9fcbc4d0"
    sha256 cellar: :any,                 ventura:        "c4b93874d54c4e53d59c390c09c7d6317eec3144d867d81d391cd4c1aa3ee0f3"
    sha256 cellar: :any,                 monterey:       "73c36ce12533b3c8c9bc6bd5a45f632297ad5aa0cb310e9ce37ad33a81b759ce"
    sha256 cellar: :any,                 big_sur:        "ac624907fb7034e07970eee9e4dae2e30ce64335f40dd3fce5cd9382ad66a249"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e54608fdf9aa72d0841d35b3aa5b37684cc139013fb46a0f37dbcf53986ad544"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "lz4"
  depends_on "lzlib"
  depends_on "openssl@3"
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
