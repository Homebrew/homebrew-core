class Librdkafka < Formula
  desc "Apache Kafka C/C++ library"
  homepage "https://github.com/confluentinc/librdkafka"
  url "https://github.com/confluentinc/librdkafka/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "d645e47d961db47f1ead29652606a502bdd2a880c85c1e060e94eea040f1a19a"
  license "BSD-2-Clause"
  head "https://github.com/confluentinc/librdkafka.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "208f157d26a48df8e85e59eb6416210b0270c61d7f9c5ca69abd7381189b5d90"
    sha256 cellar: :any,                 arm64_ventura:  "8b36d9d001260c150ff6daf09e860ff75dedc4ac6c1b1f01320ac88c497960df"
    sha256 cellar: :any,                 arm64_monterey: "63d803e4ba387ac1f52bd7fa37211e002c812c5b480bee5d3c8825a4672249c1"
    sha256 cellar: :any,                 sonoma:         "9dbfd2304c6a916db25834f834a320ab66010cf1ff227a865fa59d236af4b64d"
    sha256 cellar: :any,                 ventura:        "cc8320ea4a52b79de84ec017fa61c23a8a20ed2c9d59f1df63043d7fa124c8a5"
    sha256 cellar: :any,                 monterey:       "cb218e8ee407e456447205a1ea8fcf92963b2bf25c6cd4ed163aa5811f89597b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80ac119525092a81ac6d0306c20de38a30a3a1123b6d853c7f3bc165de85328f"
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
