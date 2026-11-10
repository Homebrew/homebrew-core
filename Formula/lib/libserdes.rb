class Libserdes < Formula
  desc "Schema ser/deserializer lib for Avro + Confluent Schema Registry"
  homepage "https://github.com/confluentinc/libserdes"
  url "https://github.com/confluentinc/libserdes.git",
      tag:      "v8.4.1",
      revision: "8cf97f7395bf5131d14bacfe896c6a5731b1f0c8"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/confluentinc/libserdes.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "18a15f5ff3791b88906ac2ae2380f82f5573aeaf0d135e7f6588eb2fc86b2d17"
    sha256 cellar: :any, arm64_tahoe:       "c6197a8f2a0f351a8b82dc23d0426354c0831b6650b37e73b3134e0f38ede0d4"
    sha256 cellar: :any, arm64_sequoia:     "053e068b00caf712ba121a87ad118ef868fcdde126b9bb5594fe51c05a0f3e22"
    sha256 cellar: :any, arm64_linux:       "6edcdb14744b5b0511b3d4df4844be807ed7da7632b4343c01013051a3d7f49d"
    sha256 cellar: :any, x86_64_linux:      "3ef9a2f653ce9a485ac8a17e4872269a49f1c9449c978e479850cca936fa7303"
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
