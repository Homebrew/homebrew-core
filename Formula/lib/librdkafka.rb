class Librdkafka < Formula
  desc "Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "2d49c35c77eeb3d42fa61c43757fcbb6a206daa560247154e60642bcdcc14d12"
  license "BSD-2-Clause"
  head "https://github.com/edenhill/librdkafka.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "85165194596d627457dc1de0b90aef0b94dc909d02874546450a2ddbd67f1802"
    sha256 cellar: :any,                 arm64_ventura:  "435d81a99efc1e7926bc10f1679d40d75d870561f304337d3b6050489bc9c810"
    sha256 cellar: :any,                 arm64_monterey: "29d03e7c4f2785776696b435eb0093e9b76e8a15fb90133dfe30a3a158e21963"
    sha256 cellar: :any,                 sonoma:         "d2fa2a81f2d788e3ca8330946a2ae6d15c925f746f1303cdc28a2692f2296e74"
    sha256 cellar: :any,                 ventura:        "1327d04f4a11cd5e25f12a1128649e3a23bd19113406da33d69e4e288f22f572"
    sha256 cellar: :any,                 monterey:       "34a540079668c37f8e502b9985290908e510fe11c07849839e599542445475c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60bc62fac8f9ca6f609e3cdf4421fd61bc93229f0b5a5996121e599cf593ea81"
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
