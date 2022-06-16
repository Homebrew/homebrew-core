class Librdkafka < Formula
  desc "Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "59b6088b69ca6cf278c3f9de5cd6b7f3fd604212cd1c59870bc531c54147e889"
  license "BSD-2-Clause"
  head "https://github.com/edenhill/librdkafka.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "62d464f0c91804cbc7e243d2947a3684fbe7f984fed62a61911c4e758274b213"
    sha256 cellar: :any,                 arm64_big_sur:  "f173038bf4ca75233c4d323dd07743d04accce68aa8513284b4ec1465a689589"
    sha256                               monterey:       "a3852aef4d08f02186ac10d3ac20dbbf5270b1ded8c8a2ceac004bfde3936488"
    sha256                               big_sur:        "40c00838eb97e3781930de8c4c743319fb126cbfd63195cd3ccc561380835c02"
    sha256                               catalina:       "00b5f82f5bdc5e71d80355125634e30ec04059fce88dac2b4560259bdabbe990"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e11b1becd5dc7eabf9f453e92cd4a9f71fa0e16ff92a07baa265021f4efebd99"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
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
