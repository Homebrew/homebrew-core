class Librdkafka < Formula
  desc "Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "6a747d293a7a4613bd2897e28e8791476fbe1ae7361f2530a876e0fd483482a6"
  license "BSD-2-Clause"
  head "https://github.com/edenhill/librdkafka.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bcb3cc5c93dd98e7ff80f352f7027433a60c319526d9bae92be12510065eff5b"
    sha256 cellar: :any,                 arm64_big_sur:  "bc890f80174ca6b7cff7a38363bf2316212d8e06ecf4c8741f629394963b0491"
    sha256                               monterey:       "b6f0c3555863c69c2a4d1a6702201a400f4b6c2ba7929da32c7c30f1a88f1a4a"
    sha256                               big_sur:        "8796c66a69f7a152b258b37a9465c921e5c818c73c3b8a552d6a833fdd72934e"
    sha256                               catalina:       "73e5a509a5a333db1ed43c37f8cb1b492b12b8a7e9ead4d99b8ae0118c0b4d07"
    sha256                               mojave:         "cc144350515cbb2ba6dbfc866d87af21cfd50d35c9222c316376b0f01a60bfda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09a57969b09efa0d39eb4fa06931ef2191e35da3fbb12e7b8cf1a53a90a57677"
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
