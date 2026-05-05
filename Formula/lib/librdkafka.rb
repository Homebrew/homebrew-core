class Librdkafka < Formula
  desc "Apache Kafka C/C++ library"
  homepage "https://github.com/confluentinc/librdkafka"
  url "https://github.com/confluentinc/librdkafka/archive/refs/tags/v2.14.1.tar.gz"
  sha256 "bb246e754dee3560e9b42bf4e844dc05de4b146a3cae937e36301ffacdc456e7"
  license "BSD-2-Clause"
  revision 1
  compatibility_version 1
  head "https://github.com/confluentinc/librdkafka.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "473e2f32919614354dba915c7438492aff65a77c01b93b0253538104a100f4d0"
    sha256 cellar: :any,                 arm64_sequoia: "451df19f4bd475e3012893be9dafff54dd5c519964070db5b9ae7312deda105d"
    sha256 cellar: :any,                 arm64_sonoma:  "23406fc6b5668da4483135c20ae500a8f249c6584618aad8088176a4292707b6"
    sha256 cellar: :any,                 sonoma:        "ecb80362a25c5275255db13812bd35381d7cc55d6a344c239819e5c3c9ee78b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe22f68c74b368d98595f75a742762edc68406c23c8857e921e36d10c55d3cb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3c4cbe41fd1a353f874f5e105c52b83e21d285b7ac0303f9eb8594350a13657"
  end

  depends_on "pkgconf" => :build
  depends_on "lz4"
  depends_on "lzlib"
  depends_on "openssl@4"
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
