class Librdkafka < Formula
  desc "Apache Kafka C/C++ library"
  homepage "https://github.com/confluentinc/librdkafka"
  url "https://github.com/confluentinc/librdkafka/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "004b1cc2685d1d6d416b90b426a0a9d27327a214c6b807df6f9ea5887346ba3a"
  license "BSD-2-Clause"
  head "https://github.com/confluentinc/librdkafka.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "68447f0c1206d32ace33c25d736a441e09c339fa9bc2edc7b702a3158aa6e70d"
    sha256 cellar: :any,                 arm64_sonoma:  "e7a756dc937b0a4b6db6aa66b053f60439979c789579f7ed26ad3b2b007a8827"
    sha256 cellar: :any,                 arm64_ventura: "c50f1413ce074882c83c22e4736922561e8001ea0f05074396f6705855a7a17e"
    sha256 cellar: :any,                 sonoma:        "f2c742931c5b92f686b6e4998bf44239fab7e3ac4d44d9893a6f4c8f4cd9af8a"
    sha256 cellar: :any,                 ventura:       "416e501dbb5d0595a9739fa5bdf7052a07f15d2735be79211795ff400438a9de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "affefbf0ce0dfeae5c7518ffa0b59d350b3b014a2270ef48cbe25765b29138cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c094c66b454f17d96f7079454452c773a738e159d7f0960fd71a0dd59681ab79"
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
