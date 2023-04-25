class Librdkafka < Formula
  desc "Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "d8e76c4b1cde99e283a19868feaaff5778aa5c6f35790036c5ef44bc5b5187aa"
  license "BSD-2-Clause"
  head "https://github.com/edenhill/librdkafka.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4c6f9e70a363d57f47fcde89e5cc38b8dcef50d01f83c91346b00f1f58f51be5"
    sha256 cellar: :any,                 arm64_monterey: "d57452d59ddb38def222c152d2c1bc7f50c178cbd09d70e7dcc36f6bef563533"
    sha256 cellar: :any,                 arm64_big_sur:  "5b08d61f21f829951ce66867fc77fc6257d4d5ecf13b53eac6f856a5aa0bf04f"
    sha256                               ventura:        "d5bcd792b0dbe151ec1b5af0e1854e6dae0e43c81492b89c379f99c4da8e4705"
    sha256                               monterey:       "917ba4ebe4f4b979f5f43b4d840260b0b4cb5de3d282115f47f3993c98cf26fa"
    sha256                               big_sur:        "60adb738c5bfb7b290581ecdf8c73072e3ab9037a5627b2f75e6d9055878b94b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc52bf8d1ecea99299b2d375b9f377056a80d1d06daed8f45285ebd24468e4df"
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
