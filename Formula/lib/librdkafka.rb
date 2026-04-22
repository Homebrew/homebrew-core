class Librdkafka < Formula
  desc "Apache Kafka C/C++ library"
  homepage "https://github.com/confluentinc/librdkafka"
  url "https://github.com/confluentinc/librdkafka/archive/refs/tags/v2.14.1.tar.gz"
  sha256 "bb246e754dee3560e9b42bf4e844dc05de4b146a3cae937e36301ffacdc456e7"
  license "BSD-2-Clause"
  compatibility_version 1
  head "https://github.com/confluentinc/librdkafka.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "95f35b537ea0904ee9f33b63e46efa8616bec1bba9b9d0776268b1ab916c5a3d"
    sha256 cellar: :any,                 arm64_sequoia: "a95dbbb70483f31adf29eec66c311e56c2e6d9b4f51c3f635d439a1d7470ca3a"
    sha256 cellar: :any,                 arm64_sonoma:  "eab8eb16d6133a9fddace0d9eddf03753fb0f52cc17616b348a3d979e6bac32e"
    sha256 cellar: :any,                 sonoma:        "77bf2f6cbb2405861cf092b4ffb466048e28fd7378b4bee3096d567fb95fcd4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61d011bb5eed6e322df92835323c36faf71e955d3db21e05ea8558b467dffc86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91552f82b23b14ff2ebb95e1e8bb1fa918ad86061cb34cb6ac1a72f372c8a277"
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
