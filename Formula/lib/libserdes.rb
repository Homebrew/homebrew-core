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
    sha256 cellar: :any, arm64_golden_gate: "95963b951c6c6ebdfdb11fad80d64425892f8dfd21517cf326264dca5f8cc7a9"
    sha256 cellar: :any, arm64_tahoe:       "54b89818ea82113639f8398c95ce28f18dc8fed5d7c5d4feb05e561a2cc4b534"
    sha256 cellar: :any, arm64_sequoia:     "cc9bb24ccf45a34a126662c8614453a0343b85e89d1628817305657a3aa1a5c2"
    sha256 cellar: :any, arm64_linux:       "a27540c0b909b9ff8787d0f9248db2ce5b0ac6d8bd3bbe5f1989b126fcbe7318"
    sha256 cellar: :any, x86_64_linux:      "25642093ed022718029b05f7e1a049e643e3c8034dfa6e1f2f32dac9d878b952"
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
