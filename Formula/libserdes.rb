class Libserdes < Formula
  desc "Schema ser/deserializer lib for Avro + Confluent Schema Registry"
  homepage "https://github.com/confluentinc/libserdes"
  url "https://github.com/confluentinc/libserdes.git",
      tag:      "v6.1.0",
      revision: "a50fed317403fdef64b95c061614a5148597f401"
  license "Apache-2.0"
  head "https://github.com/confluentinc/libserdes.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "746d1435e2cf4a5c6b015adda46584eed5139c86bbcfb379abd76d48cfe65938"
    sha256 cellar: :any, big_sur:       "10ed1c6062597c5a14399b0667e7e7404ec03011dc79a963614723cbfa406dd0"
    sha256 cellar: :any, catalina:      "c46ac3c0b4832340e989b47eaea6823b443024976ae50bc8fc87984d31852415"
    sha256 cellar: :any, mojave:        "ee2bb3f5661c65ea32a7712dd431af8c0d1a51f840f981238c3a058252ed672c"
  end

  depends_on "avro-c"
  depends_on "jansson"

  uses_from_macos "curl"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lserdes", "-o", "test"
    system "./test"
  end
end
