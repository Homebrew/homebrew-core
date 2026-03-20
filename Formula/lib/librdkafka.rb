class Librdkafka < Formula
  desc "Apache Kafka C/C++ library"
  homepage "https://github.com/confluentinc/librdkafka"
  url "https://github.com/confluentinc/librdkafka/archive/refs/tags/v2.13.2.tar.gz"
  sha256 "14972092e4115f6e99f798a7cb420cbf6daa0c73502b3c52ae42fb5b418eea8f"
  license "BSD-2-Clause"
  head "https://github.com/confluentinc/librdkafka.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ed7480ac09e99c670809a37826aca6ce9458fb1d2d7a43f4c172b067c124cb16"
    sha256 cellar: :any,                 arm64_sequoia: "26a3075e506e326388f19563e8babd2ac004b4ead23cd7abf2e304459ea993ab"
    sha256 cellar: :any,                 arm64_sonoma:  "157db5c6848b6682b6d1ef262dfe64ed91b9722470fe29ed7c924ef0e8caa5b8"
    sha256 cellar: :any,                 sonoma:        "f65151bb56ee1164112b68cecf98583cfa0205d2d7e6ca2aa2ee858a95124190"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5aa9bfb034918440e2c41542b24d203cf500f96ddb5f3497c275941c51e2318"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "988d1ca1076135373173eafce5be84c1fec7917409351f0c9a2fc9bc3e11e47f"
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
