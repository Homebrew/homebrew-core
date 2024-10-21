class Librdkafka < Formula
  desc "Apache Kafka C/C++ library"
  homepage "https://github.com/confluentinc/librdkafka"
  url "https://github.com/confluentinc/librdkafka/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "abe0212ecd3e7ed3c4818a4f2baf7bf916e845e902bb15ae48834ca2d36ac745"
  license "BSD-2-Clause"
  head "https://github.com/confluentinc/librdkafka.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "693a6fe34842b1d47c891be46f8e3908431bd4623e501053506387aa01c46800"
    sha256 cellar: :any,                 arm64_sonoma:  "0a350ffbe5862f1280f05d60b42ad56be84b96b59c6bc80b1f6f8e7c2dfaa486"
    sha256 cellar: :any,                 arm64_ventura: "45b7755b4be54acf3da779deebe109ce15c07c0f21736e776eeb6fac50d62cbf"
    sha256 cellar: :any,                 sonoma:        "9055f279bd0e7509a3f44017ca28b62528b6573141d94faad31604739947ca25"
    sha256 cellar: :any,                 ventura:       "9a47205ff702facd739a9fb17c658a4e5267f512b32f79fb352fbc1f356fd37e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c41229a894e19c9d4442d1883b12dbd362694fdc531f3d42fc56a6f573e5345"
  end

  depends_on "pkg-config" => :build
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
