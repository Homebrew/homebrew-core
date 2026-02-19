class Librdkafka < Formula
  desc "Apache Kafka C/C++ library"
  homepage "https://github.com/confluentinc/librdkafka"
  url "https://github.com/confluentinc/librdkafka/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "ac44ed450ccd2c4ab4cdeba70115e6f878d794d6df3e61c9f47902f766852058"
  license "BSD-2-Clause"
  head "https://github.com/confluentinc/librdkafka.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "973e114bee8abc100af834a2a1571ea26456373e0cb4097354a857017c11c41f"
    sha256 cellar: :any,                 arm64_sequoia: "1d69b44b03725da1ef0dcfba60ab4b66f972b9d8fa9c7018f7dd10244881cff6"
    sha256 cellar: :any,                 arm64_sonoma:  "f2011aa4cacbc8904888f7d4bbb3b70b14b691f8208dc1c60d555141ce96197e"
    sha256 cellar: :any,                 sonoma:        "b221ab1fd609d75ab7df1def9c6dbcfe11e4e54bf62a823c2b53faeb9f97166e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "041e91e277e944a9ea19718a682b2bcf4a096edfd2de9b58eb2f7c326c5a97cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d977994179f43582c738358c923c54a435fd1332b8ef2a27cbbcd5d74da4e946"
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
