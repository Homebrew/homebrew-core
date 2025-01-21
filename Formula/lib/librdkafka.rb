class Librdkafka < Formula
  desc "Apache Kafka C/C++ library"
  homepage "https://github.com/confluentinc/librdkafka"
  url "https://github.com/confluentinc/librdkafka/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "5bd1c46f63265f31c6bfcedcde78703f77d28238eadf23821c2b43fc30be3e25"
  license "BSD-2-Clause"
  head "https://github.com/confluentinc/librdkafka.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b6670afd4f2232fb7405e2aab4a74d8b4be2259f880d3de1ebe4066922333ff7"
    sha256 cellar: :any,                 arm64_sonoma:  "31a232ecf14b276474266e63eced7b314b915d1a833312373e9a83f8f2eaa9b6"
    sha256 cellar: :any,                 arm64_ventura: "6ff97c4cee0975f0e417b3859a9a68d40257a307e5a27bda9c1ba0e71da5b474"
    sha256 cellar: :any,                 sonoma:        "fede523f0f20d45fe3ccfd79753624b6888c8dd0511d468efeba3e2aff6b3eda"
    sha256 cellar: :any,                 ventura:       "260a29da8ec4683ade9e070f4b7e842aca3be797125a6e4aa81bea6ac4e1e030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27648379472cd652b18307460773699f6b93896dc9b5f48d44ca75923f07beaf"
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
