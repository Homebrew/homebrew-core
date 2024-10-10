class Librdkafka < Formula
  desc "Apache Kafka C/C++ library"
  homepage "https://github.com/confluentinc/librdkafka"
  url "https://github.com/confluentinc/librdkafka/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "abe0212ecd3e7ed3c4818a4f2baf7bf916e845e902bb15ae48834ca2d36ac745"
  license "BSD-2-Clause"
  head "https://github.com/confluentinc/librdkafka.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "3bf8b2381a201443739697cda09d78a0597835b41489180d58b642566af785fb"
    sha256 cellar: :any,                 arm64_sonoma:   "7fab9f212d5242f52c2edf3216d0b0ca1ceda3d67296a8cec1ae421b957cf271"
    sha256 cellar: :any,                 arm64_ventura:  "a1306e9b4ec059f96b35ee6ad8f5d9072c2920e48fa046140b25c256fb2f2afd"
    sha256 cellar: :any,                 arm64_monterey: "ec2b22e2d103e0ab5ed9c1a952c6738a8c97b6f68c780a8b14234090c576124b"
    sha256 cellar: :any,                 sonoma:         "0d64170898e4340b14bfa4375bda94b79eefff7845fff02d84ffe5148865950b"
    sha256 cellar: :any,                 ventura:        "5f58fd2abd9f62997e0943d332e8c9f82f7803c9f86a56b3cd0592f4e1529d91"
    sha256 cellar: :any,                 monterey:       "f1d066bb93bcdd508b2c4306f1a609ba3a5ee8efb805804f55263c9a8ffa1e24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7caf909927a31db5908751a70a1018212bf449d4c2dbc967389c1f1d5ff9028"
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
