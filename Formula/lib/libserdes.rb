class Libserdes < Formula
  desc "Schema ser/deserializer lib for Avro + Confluent Schema Registry"
  homepage "https://github.com/confluentinc/libserdes"
  url "https://github.com/confluentinc/libserdes.git",
      tag:      "v8.4.0",
      revision: "8cf97f7395bf5131d14bacfe896c6a5731b1f0c8"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/confluentinc/libserdes.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "80235fcadf45692a1c03fdb163a239bf38b146bf48e726ee79122ff8e7c8465a"
    sha256 cellar: :any, arm64_tahoe:       "625575f46ce64d0ce9980363201f4a1048644ee597bc8578cb68b13220b972b4"
    sha256 cellar: :any, arm64_sequoia:     "c93156ea9ba05e113d4e043108ac0e1277d2a65cfca2e11dbaacdafea938683d"
    sha256 cellar: :any, arm64_linux:       "1365d35f3295e9272abd7245b49dddff24cc71e9c1d69cfe48e0011b3267a69a"
    sha256 cellar: :any, x86_64_linux:      "e0c72e98f7461e2ff6b37009ff135408f420ab420cb6741d3c0b48c4490c987e"
  end

  depends_on "avro-c"
  depends_on "jansson"

  uses_from_macos "curl"

  on_macos do
    depends_on "librdkafka"
  end

  deny_network_access!

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <err.h>
      #include <stddef.h>
      #include <sys/types.h>
      #include <libserdes/serdes.h>

      int main()
      {
        char errstr[512];
        serdes_conf_t *sconf = serdes_conf_new(NULL, 0, NULL);
        serdes_t *serdes = serdes_new(sconf, errstr, sizeof(errstr));
        if (serdes == NULL) {
          errx(1, "constructing serdes: %s", errstr);
        }
        serdes_destroy(serdes);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lserdes", "-o", "test"
    system "./test"
  end
end
