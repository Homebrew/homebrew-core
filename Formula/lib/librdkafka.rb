class Librdkafka < Formula
  desc "Apache Kafka C/C++ library"
  homepage "https://github.com/confluentinc/librdkafka"
  url "https://github.com/confluentinc/librdkafka/archive/refs/tags/v2.14.2.tar.gz"
  sha256 "d7eec9c31c817fa44402f679c252dfbf97e4c338a849a25c3579a31fd127beb8"
  license "BSD-2-Clause"
  compatibility_version 1
  head "https://github.com/confluentinc/librdkafka.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8cd71ea661f7706785b535433465bd73704ca7e2b0671686bec9336b85a8fba5"
    sha256 cellar: :any, arm64_sequoia: "da178d9c26645c3fc6385afb37b2aa44fe05c15131786dc43e748cff3deae943"
    sha256 cellar: :any, arm64_sonoma:  "add84d88b22ce8f88d637549405798d7c3a69ba5ac81283293fc496cc3be9621"
    sha256 cellar: :any, sonoma:        "44ec642d08f751d0c6b735cbb56d7d3113220423da97a8bd43ea05f8c605949b"
    sha256 cellar: :any, arm64_linux:   "c50f5703247113fcd3cc51fb563e0733ace60174dcff1b888abc3b59c9a08cda"
    sha256 cellar: :any, x86_64_linux:  "80b11c36ecfc5e51794e846b1156b9eaecdc6b98bc58987082fa6eee037a6072"
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
