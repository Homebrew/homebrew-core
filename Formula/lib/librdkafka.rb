class Librdkafka < Formula
  desc "Apache Kafka C/C++ library"
  homepage "https://github.com/confluentinc/librdkafka"
  url "https://github.com/confluentinc/librdkafka/archive/refs/tags/v2.12.1.tar.gz"
  sha256 "ec103fa05cb0f251e375f6ea0b6112cfc9d0acd977dc5b69fdc54242ba38a16f"
  license "BSD-2-Clause"
  head "https://github.com/confluentinc/librdkafka.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0c91c7a4a6c7e4f45b8cd4d54a435e36e6ec96c4781f0ec8c12ab1f8120bdcb1"
    sha256 cellar: :any,                 arm64_sequoia: "166433b0f5b245f42396d5edf0b2fdc31e4b6d2f3396c46f573b9a30c7f259c8"
    sha256 cellar: :any,                 arm64_sonoma:  "982fa0b3ef63fa414eca97f3c322830ec9d3974c22d431273fd32e108524bb04"
    sha256 cellar: :any,                 sonoma:        "ac9114e91affcfa254f1fbe4f423ebf2974123e022590411a9990ee5d21cf6cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "901c8fbadf514fb7fb0cede1732e69f5fd32bd319f559aa5f233f09fb631c986"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e867d8e1ec8e8f3863bb169c40562605540ec029a252ce7456729eeff0b210d"
  end

  depends_on "pkgconf" => :build
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
