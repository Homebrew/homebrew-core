class Librdkafka < Formula
  desc "Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "f321bcb1e015a34114c83cf1aa7b99ee260236aab096b85c003170c90a47ca9d"
  license "BSD-2-Clause"
  head "https://github.com/edenhill/librdkafka.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "086f392afe735419313bfa2ff5d43fb0cee93a646e8fe9693a99f4b9b65bd6da"
    sha256 cellar: :any,                 arm64_monterey: "84902ffb318dc778fddfaa97cc6083659be8de469e5e9f3efc71579a0a240667"
    sha256 cellar: :any,                 arm64_big_sur:  "3ad3d82ce088464c7932fc79a54cfb8b01fb4b8e813a8f5b6b3f446dc417950f"
    sha256                               ventura:        "51d853afb8c8cbaf269d9758d7d3f2be498f03ca19eeeb7a28bef487db34079f"
    sha256                               monterey:       "b29f37dfdda86629d1b912f922adc413bac458c8d8b025be2e7267bbb55ca6cf"
    sha256                               big_sur:        "12e5f6d2cbb0f39cd45f0d1cc25cc62ab38f44d2bcaacc7ad833e74e23590cb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47ac99e8d522316918ff5ebdd3449dc1f02f5ee4111557ffbb8efda04f49bc9b"
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
