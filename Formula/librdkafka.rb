class Librdkafka < Formula
  desc "Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/v1.6.0.tar.gz"
  sha256 "3130cbd391ef683dc9acf9f83fe82ff93b8730a1a34d0518e93c250929be9f6b"
  license "BSD-2-Clause"
  head "https://github.com/edenhill/librdkafka.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "1700456f7c796346d69369ff969b2cec001c4fb602e5d55db8121c7dc2ab78a9"
    sha256 big_sur:       "860c7e63fcdf6eb225a19ed41129209b7e35109f63506b1eae9ce99409533dfe"
    sha256 catalina:      "8f9ba2426166a7d12cf82570a1fe08eb569f00935757c0105dab8fc4f7c37772"
    sha256 mojave:        "f067008cc0245579c74f656d90f8f1c886fde639d1b6c45414c497e9a260ac40"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "lz4"
  depends_on "lzlib"
  depends_on "openssl@1.1"
  depends_on "zstd"

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
