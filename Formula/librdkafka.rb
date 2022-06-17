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
    sha256 cellar: :any,                 arm64_monterey: "bbe7efc09d58c2fd56280eb749883b330d7f066735be640911cea5e008bab6fa"
    sha256 cellar: :any,                 arm64_big_sur:  "a968ca656ec63e71753b2395644e3dd44726ca0209b8ec91c7d6526996295487"
    sha256                               monterey:       "e6dfc5611882ec374b65b755444660d3fbdfab9997c236727be634e72ce99f7c"
    sha256                               big_sur:        "8e88fde055b1d98af5057a62c370a38f2304be3f6f841730e928411dd52561ff"
    sha256                               catalina:       "06f64895903107cbb5935bfad7b75edac9651200724f84bb6065e7480927dc45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3378b6b454f5578cf242518b0262e0184313f15d927b6bc6c20f564294238cc4"
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
