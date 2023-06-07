class Librdkafka < Formula
  desc "Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "7be1fc37ab10ebdc037d5c5a9b35b48931edafffae054b488faaff99e60e0108"
  license "BSD-2-Clause"
  head "https://github.com/edenhill/librdkafka.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c2c2b9a45368d7bcda651b619ebe2cfcbe68358fb0fdda7e5f419d8f2d11a4ac"
    sha256 cellar: :any,                 arm64_monterey: "4b6b59aa0113e3d102f61131093e0b869f7d47179890610f8fa2f6fb566bf6f2"
    sha256 cellar: :any,                 arm64_big_sur:  "6f2517df4b4f9b6dd5c8810c3d498ed13c58f74c54ecae7185d9f8b0355825c8"
    sha256                               ventura:        "270a111b7c2f9f55ba30ca04ef601cf4777caa5a422e8f636e0277647a183bc9"
    sha256                               monterey:       "6b0482bee2c64846346fc449d944b810f662e1a71b90edcae870920b120bff15"
    sha256                               big_sur:        "b373c974475fd282fbc88448fd106553ed70ab3c48f57a851f3b8a047aa8d4ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b39c1f148e2399a5b9f59c310b169e055afa662d1214be2c560bf0c077da6506"
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
