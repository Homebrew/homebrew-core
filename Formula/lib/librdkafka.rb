class Librdkafka < Formula
  desc "Apache Kafka C/C++ library"
  homepage "https://github.com/confluentinc/librdkafka"
  url "https://github.com/confluentinc/librdkafka/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "c05c03ef00a13a8463fac3e8918c04843c416f11ced58c889d806a88ca92cf99"
  license "BSD-2-Clause"
  compatibility_version 1
  head "https://github.com/confluentinc/librdkafka.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d1f8acfccf7fae6efe0ac9465e40cacd463123f33d23d189d244402ed1fed208"
    sha256 cellar: :any,                 arm64_sequoia: "f101a9c07236625979f3495048fdbee9ebe74fd0395168f71fabb103b6d3f6ca"
    sha256 cellar: :any,                 arm64_sonoma:  "506eea98de3efd0e0b08597a727c7f37a0493143bad78f89958dd6f5050ec4d1"
    sha256 cellar: :any,                 sonoma:        "e956b84facc5e5b4d655b2bd1ddd041f63927f0babfb82c03133e4869bad88cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f72a73238a7bce8adbee0556bf0862a62a0cd416239f13293694abd9659b100"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2549d33905732c2bcb8cd8ade784d32f57deedb6438158c250bd1a2e362f8cfd"
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
