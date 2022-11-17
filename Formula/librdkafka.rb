class Librdkafka < Formula
  desc "Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "3fba157a9f80a0889c982acdd44608be8a46142270a389008b22d921be1198ad"
  license "BSD-2-Clause"
  head "https://github.com/edenhill/librdkafka.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fa9511e6ed4fa44e60d2b6f1f380d7c646b8aaedd10ecbe564b7650ac35c43b3"
    sha256 cellar: :any,                 arm64_monterey: "51cf809caf8626828668859f212e29dd644a8cbe6bbd1740c10edf0b565f0c2f"
    sha256 cellar: :any,                 arm64_big_sur:  "71fd99b66724e9cde7fc862eadd2043b3c0a072c5ef564d6400da24b47e4d26c"
    sha256                               ventura:        "abb618447accfb2ba3138ed01a4ed336aa904961a38cc828c25ded2e03fe1cfd"
    sha256                               monterey:       "9b56f5818e278cec646eb2c93f3d32b19eddfeacb1ec96bff9ba95b7232031fd"
    sha256                               big_sur:        "939f96a1a1f5fc8caeeb5e0256fe2ea3a319d27f7519739b2699aef96f1bbebb"
    sha256                               catalina:       "09dee2fe5791509406023eb4510bd19ac9f32e675adbfebcdba3288864927083"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "939c1bf09ef24b036644cb8cd1f15c517e74f4ea6f015082308ac828ad135ee0"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
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
