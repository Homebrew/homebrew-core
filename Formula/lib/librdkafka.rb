class Librdkafka < Formula
  desc "Apache Kafka C/C++ library"
  homepage "https://github.com/confluentinc/librdkafka"
  url "https://github.com/confluentinc/librdkafka/archive/refs/tags/v2.11.1.tar.gz"
  sha256 "a2c87186b081e2705bb7d5338d5a01bc88d43273619b372ccb7bb0d264d0ca9f"
  license "BSD-2-Clause"
  head "https://github.com/confluentinc/librdkafka.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e09b3ad3286306622578e478d9ca6939f1ab78f8775548d483006c211969a290"
    sha256 cellar: :any,                 arm64_sequoia: "57ab313db1cdec5aee680799d5e36340bdea55f83d3a0d1a3be3a1f135835eda"
    sha256 cellar: :any,                 arm64_sonoma:  "ffc9957ad419eb93820213c7070897d305c6b8d9a573786a23d74fe3555b7f53"
    sha256 cellar: :any,                 arm64_ventura: "f2418eae892e203c5a18cd4c610aadf3f3fc5d8a273ec52742f93a035259f077"
    sha256 cellar: :any,                 sonoma:        "4c4fa5558d3e9b4cf23f0fd855c36ca0d0ac69c2bfdf1056de977043a585c727"
    sha256 cellar: :any,                 ventura:       "8e3320de9f10c88c3587b6fb3b0e2320b5b52482dc25c569e2fa32760a143dec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ced527c4e67727a98a9af1c65fab7c5cc9c680bdf91d0af9cd6eb15be983c0bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34d960c31cdd086cd4440d68fcb62cb7a9b85133cc90f6680aa5d891c5857072"
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
