class Librdkafka < Formula
  desc "Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/v1.7.0.tar.gz"
  sha256 "c71b8c5ff419da80c31bb8d3036a408c87ad523e0c7588e7660ee5f3c8973057"
  license "BSD-2-Clause"
  head "https://github.com/edenhill/librdkafka.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "39f230cfacc4a83227ddd04269a10aec5e3ff8dbe843ddc77615c6163eed9de0"
    sha256                               big_sur:       "3ec79e37ef21015419739012106ec51199fa50ec71a5843bf97a9bbcd3dd0fc5"
    sha256                               catalina:      "40a7854b189f58305028f1977497b9f9d979ebb1f941835b31898da3e5b64e08"
    sha256                               mojave:        "1d640334758e0049452c87e1dbf264dcbe2f951334f5c49e6e0760480ead6379"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e16dd5a3da2f4360890b21c6899cefb1803317345f0ec6fb8cd074f815c426e"
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
