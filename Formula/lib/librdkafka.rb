class Librdkafka < Formula
  desc "Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "af9a820cbecbc64115629471df7c7cecd40403b6c34bfdbb9223152677a47226"
  license "BSD-2-Clause"
  head "https://github.com/edenhill/librdkafka.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "100c737517e945a58ff2ef71560b95f6aadbec649b2a186103784efe02346f8f"
    sha256 cellar: :any,                 arm64_ventura:  "91e98b17ca4c6bbee37a634e9cf3fd19f72ff5edaea5934c8fe8ee7c27c64654"
    sha256 cellar: :any,                 arm64_monterey: "2b27eb2e36a1eff3967c3fec07e0dbed6299411d998ad9b715494d1a8ae50654"
    sha256 cellar: :any,                 arm64_big_sur:  "35fb9a91ce202711c608a218cd6509794d5c1b4f2751eb800c0853d8efdcc00e"
    sha256 cellar: :any,                 sonoma:         "fbe6b985f71b51c35e38426d03af34b913e50a446727eae289d06ce90e90e2db"
    sha256 cellar: :any,                 ventura:        "52f58b12803a20cff5a54b1e03a2ce67b5d78b7cd5f251ac92ae09328665e910"
    sha256 cellar: :any,                 monterey:       "5cefdf9907f2aa15ae227093ccf8ac92c857b1f090a47c49aaee8d8cbc2ba49d"
    sha256 cellar: :any,                 big_sur:        "eaef451b34672e75ec41814c889a7ca34fe1f90c6764a634e56a81ee9c58abc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "180f58f10a8378242848a3fda47e672421f7cb4c309eb4d6ee73c582519357dc"
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
