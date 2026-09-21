class Librdkafka < Formula
  desc "Apache Kafka C/C++ library"
  homepage "https://github.com/confluentinc/librdkafka"
  url "https://github.com/confluentinc/librdkafka/archive/refs/tags/v2.15.1.tar.gz"
  sha256 "23c8575c7d1ced07246cb9cf200c11325b72201fd4134a02414ca869fbdd8ed3"
  license "BSD-2-Clause"
  compatibility_version 1
  head "https://github.com/confluentinc/librdkafka.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "fee19ffd81582acf6edf60b0da2f07232549382601dbe53388da5389adc5c5d7"
    sha256 cellar: :any, arm64_tahoe:       "ed3fb41a87771c4c1c049b6247daaf5adc8660d20ae743596617401913ee4890"
    sha256 cellar: :any, arm64_sequoia:     "a7a62196cda98ceca6af3edcf735df04d103dc44e4af131ec28ee2d4ca419c33"
    sha256 cellar: :any, arm64_sonoma:      "5600c0b03159960f3b59363f279dc4f9f0a416333c60e2a2ebf6cffcec89ced9"
    sha256 cellar: :any, arm64_linux:       "1a510d17417be5a3e4eee56b731a579145faf12d06dd591734aa24986435a378"
    sha256 cellar: :any, x86_64_linux:      "d6226b9e6c404280c5921da0a4ae407b05a7e971160008ae7859841f72270afa"
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
